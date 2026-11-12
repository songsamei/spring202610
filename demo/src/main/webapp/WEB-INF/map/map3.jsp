jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>카카오 지도 및 로드뷰</title>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="/js/page-change.js"></script>

<!-- 카카오 지도 API -->
<script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8e5483494baa2213a35ff6b0b3b9ffee&libraries=services"></script>

<style>

/* 전체 지도 영역 */
.map_wrap, .map_wrap * {
    margin: 0;
    padding: 0;
    font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
    font-size: 12px;
}

.map_wrap {
    position: relative;
    width: 100%;
}

/* 지도와 로드뷰 영역 */
.map_area {
    display: flex;
    width: 100%;
    height: 500px;
}

#map {
    width: 70%;
    height: 100%;
}

#roadview {
    width: 30%;
    height: 100%;
    background: #eee;
}

/* 검색 영역 */
#menu_wrap {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    width: 250px;
    margin: 10px 0 30px 10px;
    padding: 5px;
    overflow-y: auto;
    background: rgba(255, 255, 255, 0.9);
    z-index: 2;
    border-radius: 10px;
}

#menu_wrap .option {
    text-align: center;
}

#menu_wrap .option p {
    margin: 10px 0;
}

#menu_wrap .option input,
#menu_wrap .option select {
    width: 145px;
    height: 25px;
    margin: 5px 0;
}

#menu_wrap .option button {
    margin-left: 5px;
    padding: 3px 7px;
    cursor: pointer;
}

#placesList li {
    list-style: none;
}

#placesList .item {
    position: relative;
    border-bottom: 1px solid #888;
    overflow: hidden;
    cursor: pointer;
    min-height: 65px;
}

#placesList .item span {
    display: block;
    margin-top: 4px;
}

#placesList .item h5,
#placesList .item .info {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
}

#placesList .item .info {
    padding: 10px 0 10px 55px;
}

#placesList .info .gray {
    color: #8a8a8a;
}

#placesList .info .jibun {
    padding-left: 26px;
    background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;
}

#placesList .info .tel {
    color: #009900;
}

#placesList .item .markerbg {
    float: left;
    position: absolute;
    width: 36px;
    height: 37px;
    margin: 10px 0 0 10px;
    background: url(https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;
}

#placesList .item .marker_1 { background-position: 0 -10px; }
#placesList .item .marker_2 { background-position: 0 -56px; }
#placesList .item .marker_3 { background-position: 0 -102px; }
#placesList .item .marker_4 { background-position: 0 -148px; }
#placesList .item .marker_5 { background-position: 0 -194px; }
#placesList .item .marker_6 { background-position: 0 -240px; }
#placesList .item .marker_7 { background-position: 0 -286px; }
#placesList .item .marker_8 { background-position: 0 -332px; }
#placesList .item .marker_9 { background-position: 0 -378px; }
#placesList .item .marker_10 { background-position: 0 -423px; }
#placesList .item .marker_11 { background-position: 0 -470px; }
#placesList .item .marker_12 { background-position: 0 -516px; }
#placesList .item .marker_13 { background-position: 0 -562px; }
#placesList .item .marker_14 { background-position: 0 -608px; }
#placesList .item .marker_15 { background-position: 0 -654px; }

/* 페이지 번호 */
#pagination {
    margin: 10px auto;
    text-align: center;
}

#pagination a {
    display: inline-block;
    margin-right: 10px;
}

#pagination .on {
    font-weight: bold;
    cursor: default;
    color: #777;
}

/* 로드뷰 안내 */
.roadview_info {
    position: absolute;
    top: 10px;
    right: 10px;
    z-index: 1;
    background: white;
    padding: 8px;
    border-radius: 5px;
}

/* 모바일 */
@media screen and (max-width: 768px) {

    .map_area {
        flex-direction: column;
        height: 700px;
    }

    #map {
        width: 100%;
        height: 400px;
    }

    #roadview {
        width: 100%;
        height: 300px;
    }

    #menu_wrap {
        width: 190px;
        max-height: 380px;
    }

}

</style>
</head>

<body>

<div id="app">

    <div class="map_wrap">

        <!-- 지도와 로드뷰 -->
        <div class="map_area">

            <!-- 지도 -->
            <div id="map"></div>

            <!-- 로드뷰 -->
            <div id="roadview"></div>

        </div>

        <!-- 검색 영역 -->
        <div id="menu_wrap">

            <div class="option">

                <!-- 키워드 검색 -->
                <form @submit.prevent="searchPlaces">

                    <p>키워드 검색</p>

                    <input type="text"
                        v-model="keyword"
                        placeholder="검색어 입력">

                    <button type="submit">검색</button>

                </form>

                <hr>

                <!-- 카테고리 검색 -->
                <div>

                    <p>카테고리 검색</p>

                    <select v-model="categoryCode"
                        @change="searchCategory">

                        <option value="">:: 선택 ::</option>
                        <option value="MT1">대형마트</option>
                        <option value="CS2">편의점</option>
                        <option value="PS3">어린이집, 유치원</option>
                        <option value="SC4">학교</option>
                        <option value="AC5">학원</option>
                        <option value="PK6">주차장</option>
                        <option value="OL7">주유소, 충전소</option>
                        <option value="SW8">지하철역</option>
                        <option value="BK9">은행</option>
                        <option value="CT1">문화시설</option>
                        <option value="AG2">중개업소</option>
                        <option value="PO3">공공기관</option>
                        <option value="AT4">관광명소</option>
                        <option value="AD5">숙박</option>
                        <option value="FD6">음식점</option>
                        <option value="CE7">카페</option>
                        <option value="HP8">병원</option>
                        <option value="PM9">약국</option>

                    </select>

                </div>

            </div>

            <hr>

            <!-- 검색 결과 목록 -->
            <ul id="placesList"></ul>

            <!-- 페이지 번호 -->
            <div id="pagination"></div>

        </div>

    </div>

</div>

<script>

const app = Vue.createApp({

    data() {

        return {

            // 지도 객체
            map: null,

            // 장소 검색 객체
            ps: null,

            // 인포윈도우
            infowindow: null,

            // 마커 배열
            markers: [],

            // 로드뷰 객체
            roadview: null,

            // 로드뷰 클라이언트
            roadviewClient: null,

            // 키워드
            keyword: '삼척',

            // 카테고리 코드
            categoryCode: ''

        };

    },

    methods: {

        // 지도 및 로드뷰 초기화
        fnInit: function() {

            let self = this;

            // 지도 생성
            var mapContainer = document.getElementById('map');

            var mapOption = {

                center: new kakao.maps.LatLng(
                    37.566826,
                    126.9786567
                ),

                level: 3

            };

            self.map = new kakao.maps.Map(
                mapContainer,
                mapOption
            );

            // 장소 검색 객체
            self.ps = new kakao.maps.services.Places(
                self.map
            );

            // 인포윈도우
            self.infowindow = new kakao.maps.InfoWindow({

                zIndex: 1

            });

            // 로드뷰 컨테이너
            var roadviewContainer =
                document.getElementById('roadview');

            // 로드뷰 생성
            self.roadview = new kakao.maps.Roadview(
                roadviewContainer
            );

            // 로드뷰 클라이언트 생성
            self.roadviewClient =
                new kakao.maps.RoadviewClient();

            // 최초 키워드 검색
            self.searchPlaces();

        },

        // 키워드 검색
        searchPlaces: function() {

            let self = this;

            var keyword = self.keyword.trim();

            if (!keyword) {

                alert('키워드를 입력해주세요!');

                return;

            }

            // 카테고리 초기화
            self.categoryCode = '';

            // 기존 검색 결과 삭제
            self.clearSearchResult();

            // 키워드 검색
            self.ps.keywordSearch(

                keyword,

                function(data, status, pagination) {

                    self.placesSearchCB(
                        data,
                        status,
                        pagination
                    );

                }

            );

        },

        // 카테고리 검색
        searchCategory: function() {

            let self = this;

            if (!self.categoryCode) {

                self.clearSearchResult();

                return;

            }

            // 기존 검색 결과 삭제
            self.clearSearchResult();

            // 카테고리 검색
            self.ps.categorySearch(

                self.categoryCode,

                function(data, status, pagination) {

                    self.placesSearchCB(
                        data,
                        status,
                        pagination
                    );

                },

                {

                    useMapBounds: true

                }

            );

        },

        // 검색 결과 초기화
        clearSearchResult: function() {

            let self = this;

            self.removeAllChildNods(
                document.getElementById('placesList')
            );

            self.removeAllChildNods(
                document.getElementById('pagination')
            );

            self.removeMarker();

            self.infowindow.close();

        },

        // 검색 완료 콜백
        placesSearchCB: function(
            data,
            status,
            pagination
        ) {

            let self = this;

            if (status === kakao.maps.services.Status.OK) {

                self.displayPlaces(data);

                self.displayPagination(pagination);

            } else if (
                status === kakao.maps.services.Status.ZERO_RESULT
            ) {

                self.clearSearchResult();

                alert('검색 결과가 존재하지 않습니다.');

            } else if (
                status === kakao.maps.services.Status.ERROR
            ) {

                alert('검색 중 오류가 발생했습니다.');

            }

        },

        // 검색 결과 목록 및 마커 출력
        displayPlaces: function(places) {

            let self = this;

            var listEl =
                document.getElementById('placesList');

            var menuEl =
                document.getElementById('menu_wrap');

            var fragment =
                document.createDocumentFragment();

            var bounds =
                new kakao.maps.LatLngBounds();

            self.removeAllChildNods(listEl);

            self.removeMarker();

            self.infowindow.close();

            for (var i = 0; i < places.length; i++) {

                var place = places[i];

                // 장소 좌표
                var placePosition =
                    new kakao.maps.LatLng(
                        place.y,
                        place.x
                    );

                // 마커 생성
                var marker = self.addMarker(
                    placePosition,
                    i
                );

                // 검색 목록 생성
                var itemEl = self.getListItem(
                    i,
                    place
                );

                bounds.extend(placePosition);

                // 마커 이벤트 등록
                (function(marker, place, vm, itemEl) {

                    // 마커 클릭
                    kakao.maps.event.addListener(
                        marker,
                        'click',
                        function() {

                            // 인포윈도우 표시
                            vm.displayInfowindow(
                                marker,
                                place.place_name
                            );

                            // 해당 위치 로드뷰 표시
                            vm.displayRoadview(
                                placePositionOf(place)
                            );

                        }
                    );

                    // 목록 클릭
                    itemEl.onclick = function() {

                        vm.map.setCenter(
                            marker.getPosition()
                        );

                        vm.displayInfowindow(
                            marker,
                            place.place_name
                        );

                        vm.displayRoadview(
                            marker.getPosition()
                        );

                    };

                    // 목록 마우스 오버
                    itemEl.onmouseover = function() {

                        vm.displayInfowindow(
                            marker,
                            place.place_name
                        );

                    };

                    // 목록 마우스 아웃
                    itemEl.onmouseout = function() {

                        vm.infowindow.close();

                    };

                    // 장소 좌표 반환
                    function placePositionOf(place) {

                        return new kakao.maps.LatLng(
                            place.y,
                            place.x
                        );

                    }

                })(marker, place, self, itemEl);

                fragment.appendChild(itemEl);

            }

            listEl.appendChild(fragment);

            menuEl.scrollTop = 0;

            // 검색 결과 범위로 지도 이동
            if (places.length > 0) {

                self.map.setBounds(bounds);

            }

        },

        // 검색 목록 생성
        getListItem: function(index, places) {

            var el = document.createElement('li');

            var itemStr =

                '<span class="markerbg marker_' +
                (index + 1) +
                '"></span>' +

                '<div class="info">' +

                '<h5>' +
                places.place_name +
                '</h5>';

            if (places.road_address_name) {

                itemStr +=

                    '<span>' +
                    places.road_address_name +
                    '</span>' +

                    '<span class="jibun gray">' +
                    places.address_name +
                    '</span>';

            } else {

                itemStr +=

                    '<span>' +
                    places.address_name +
                    '</span>';

            }

            if (places.phone) {

                itemStr +=

                    '<span class="tel">' +
                    places.phone +
                    '</span>';

            }

            itemStr += '</div>';

            el.innerHTML = itemStr;

            el.className = 'item';

            return el;

        },

        // 마커 생성
        addMarker: function(position, idx) {

            let self = this;

            var imageSrc =
                'https://t1.kakaocdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';

            var imageSize =
                new kakao.maps.Size(36, 37);

            var imgOptions = {

                spriteSize:
                    new kakao.maps.Size(36, 691),

                spriteOrigin:
                    new kakao.maps.Point(
                        0,
                        (idx * 46) + 10
                    ),

                offset:
                    new kakao.maps.Point(13, 37)

            };

            var markerImage =
                new kakao.maps.MarkerImage(
                    imageSrc,
                    imageSize,
                    imgOptions
                );

            var marker = new kakao.maps.Marker({

                map: self.map,

                position: position,

                image: markerImage

            });

            self.markers.push(marker);

            return marker;

        },

        // 마커 전체 삭제
        removeMarker: function() {

            let self = this;

            for (var i = 0; i < self.markers.length; i++) {

                self.markers[i].setMap(null);

            }

            self.markers = [];

        },

        // 인포윈도우 표시
        displayInfowindow: function(marker, title) {

            let self = this;

            var content =

                '<div style="padding:5px;font-size:12px;white-space:nowrap;">' +

                title +

                '</div>';

            self.infowindow.setContent(content);

            self.infowindow.open(
                self.map,
                marker
            );

        },

        // 로드뷰 표시
        displayRoadview: function(position) {

            let self = this;

            // 해당 좌표에서 가장 가까운 로드뷰 파노라마 검색
            self.roadviewClient.getNearestPanoId(

                position,

                50,

                function(panoId) {

                    if (panoId === null) {

                        alert('해당 위치 주변에는 로드뷰가 존재하지 않습니다.');

                        return;

                    }

                    // 로드뷰 표시
                    self.roadview.setPanoId(
                        panoId,
                        position
                    );

                }

            );

        },

        // 페이지 번호 출력
        displayPagination: function(pagination) {

            let self = this;

            var paginationEl =
                document.getElementById('pagination');

            var fragment =
                document.createDocumentFragment();

            self.removeAllChildNods(paginationEl);

            for (
                var i = 1;
                i <= pagination.last;
                i++
            ) {

                var el = document.createElement('a');

                el.href = '#';

                el.innerHTML = i;

                if (i === pagination.current) {

                    el.className = 'on';

                } else {

                    el.onclick = (function(i) {

                        return function(event) {

                            event.preventDefault();

                            self.infowindow.close();

                            pagination.gotoPage(i);

                        };

                    })(i);

                }

                fragment.appendChild(el);

            }

            paginationEl.appendChild(fragment);

        },

        // 자식 요소 전체 삭제
        removeAllChildNods: function(el) {

            while (el.hasChildNodes()) {

                el.removeChild(el.lastChild);

            }

        }

    },

    mounted() {

        this.fnInit();

    }

});

app.mount('#app');

</script>

</body>
</html>