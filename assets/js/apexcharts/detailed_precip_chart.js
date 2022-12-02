import ApexCharts from 'apexcharts'

const DetailedPrecipChart = {
  createChart(options) {
    var chart = new ApexCharts(document.querySelector("#DetailedPrecipChart"), options);
    this.chart = chart
    chart.render();
  },
  chartOptions(seriesData, station_name, station_elevation) {
    // let numbers = []
    // if (seriesData == null) {
    //   oldData = []
    // }else{
    //   splitSeries = seriesData.split("\"")
    //   for(let x = 0; x < splitSeries.length; x++){
    //     num = parseInt(splitSeries[x])
    //     if (num >= 0){
    //       numbers.push(parseInt(num))
    //     }
    //   }
    //   oldData = numbers
    // }
    console.log(seriesData)
    let numbers = []
    for(let x = 0; x < seriesData.length; x++){
          num = parseInt(seriesData[x])
          if (num >= 0){
            numbers.push(parseInt(num))
          }
    }
    seriesData = numbers.reverse()
    var options = {
      series: [{
        name: "Desktops",
        data: seriesData
    }],
      chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false
      }
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      curve: 'straight'
    },
    title: {
      text: station_name + " (Elevation: " + station_elevation +"ft)",
      align: 'left'
    },
    grid: {
      row: {
        colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
        opacity: 0.5
      },
    },
    xaxis: {
      categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
    }
    };

    // var options = {
    //   chart: {
    //     id: 'DetailedPrecipChart',
    //     height: '350px',
    //     type: 'line',
    //     offsetY: 10,
    //     toolbar: {
    //       tools: {
    //         // eslint-disable-next-line prettier/prettier
    //         download: '<img src="/images/download_icon.png" width="50" height="50" />',
    //         selection: false,
    //         zoom: false,
    //         zoomin: false,
    //         zoomout: false,
    //         pan: false,
    //         reset: false
    //       }
    //     }
    //   },
    //   dataLabels: {
    //     enabled: false
    //   },
    //   title: {
    //     text: 'Historical Precipitation',
    //     margin: 10,
    //     offsetY: -5,
    //     floating: true,
    //     align: 'center'
    //   },
    //   legend: {
    //     position: 'bottom',
    //     itemMargin: {
    //       horizontal: 10,
    //       vertical: 15
    //     },
    //     show: false
    //   },
    //   stroke: {
    //     curve: 'straight',
    //     width: 3
    //   },
    //   colors: ['#FEB019', '#00E396', '#008FFB'],
    //   xaxis: {
    //     type: 'datetime',
    //     labels: {
    //       format: 'MMM'
    //     }
    //   },
    //   yaxis: {
    //     labels: {
    //       formatter(value) {
    //         return value + '%'
    //       }
    //     }
    //   },
    //   tooltip: {
    //     x: {
    //       format: 'MMM d',
    //       formatter: undefined
    //     }
    //   },
    //   series: seriesData
    // }
    return options
  },
  calcChartData(location) {
    const seriesData = [
      { name: 'High % Precip', data: this.getHighPrecipData(location) },
      { name: 'Avg % Precip', data: this.getAvgPrecipData(location) },
      { name: 'Low % Precip', data: this.getLowPrecipData(location) }
    ]
    return seriesData
  },
  mounted() {
    const api_response = this.el.getAttribute("api_response")
    const station_name = this.el.getAttribute("station_name")
    if ((api_response !== undefined) && (!Array.isArray(api_response))) {
      this.createChart(this.chartOptions('swag', station_name))
    }
    this.handleEvent("clicked", data => {
      let station_name = data.station_name
      let api_data = data.api_response
      let station_elevation = data.station_elevation
      this.chart.updateOptions((this.chartOptions(api_data, station_name, station_elevation)))
    })
  },
  updated() {
    // console.log("Updating Chart")
    const selectedLocation = this.el.getAttribute("api_response")
    const station_name = this.el.getAttribute("station_name")
    // console.log(selectedLocation)
    this.createChart(this.chartOptions(selectedLocation, station_name))

    // if ((selectedLocation !== undefined) && (!Array.isArray(selectedLocation))) {
    //   // ApexCharts.exec('DetailedPrecipChart', 'updateSeries', newSeriesData, true);
    // } else {
    //   ApexCharts.exec('DetailedPrecipChart', 'updateSeries', [], true);
    // }
  },
  getHighPrecipData(location) {
    return this.filterPrecipData(location, '75th percentiles of daily nonzero precipitation totals for 29-day windows centered on each day of the year')
  },
  getAvgPrecipData(location) {
    return this.filterPrecipData(location, '50th percentiles of daily nonzero precipitation totals for 29-day windows centered on each day of the year')
  },
  getLowPrecipData(location) {
    return this.filterPrecipData(location, '25th percentiles of daily nonzero precipitation totals for 29-day windows centered on each day of the year')
  },
  filterPrecipData(location, metric) {
    const selectedLocations = location
    return selectedLocations.station.observations
      .filter((obs) => obs.metric === metric)
      .sort((a, b) => a.month - b.month || a.day - b.day)
      .map((obs) => {
        return {
          x:
            String(obs.month).padStart(2, '0') +
            '/' +
            String(obs.day).padStart(2, '0') +
            '/' +
            '2020',
          y: obs.value
        }
      })
  }
}

export default DetailedPrecipChart