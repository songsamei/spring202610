<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
</head>

<body>
    <div id="app">
        <h2>상품별 판매 합계</h2>
        <div id="chart"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                list: [],
                chart: null
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnChart: function () {
                let self = this;
                let param = {}
                $.ajax({
                    url: "http://localhost:8080/product/sum.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("서버 데이터:", data);
                        self.list = data.list;

                        let chartData = self.list.map(item => {
                            return {
                                x: item.productName,
                                y: Number(item.sum)
                            };
                        });

                        let options = {

                            chart: {
                                type: 'bar',
                                height: 350
                            },

                            series: [{
                                name: '판매 합계',
                                data: chartData
                            }],

                            xaxis: {
                                type: 'category'
                            },

                            dataLabels: {
                                enabled: true
                            },

                            title: {
                                text: '상품별 판매 합계'
                            }

                        };

                        self.chart = new ApexCharts(
                            document.querySelector("#chart"),
                            options
                        );
                        self.chart.render();
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            this.fnChart();

        }
    });
    app.mount('#app');
</script>


