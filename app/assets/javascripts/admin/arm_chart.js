$(document).on('turbolinks:load', function() {
  if(window.location.href === window.location.protocol + "//" + window.location.host + "/admin/dashboard"
    || window.location.href === window.location.protocol + "//" + window.location.host + "/admin") {
    $.ajax({
      url: "/admin/dashboard",
      type: 'GET',
      data: {},
      dataType: 'json',
      success: function (res) {
        am4core.ready(function () {
          am4core.useTheme(am4themes_animated);

          var chart = am4core.create("chartdiv", am4charts.XYChart);
          chart.hiddenState.properties.opacity = 0;
          chart.data = res.data_exchange_items
          var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
          categoryAxis.renderer.grid.template.location = 0;
          categoryAxis.dataFields.category = "month";
          categoryAxis.renderer.minGridDistance = 40;

          var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

          var series = chart.series.push(new am4charts.CurvedColumnSeries());
          series.dataFields.categoryX = "month";
          series.dataFields.valueY = "value";
          series.tooltipText = "{valueY.value}"
          series.columns.template.strokeOpacity = 0;

          series.columns.template.fillOpacity = 0.75;

          var hoverState = series.columns.template.states.create("hover");
          hoverState.properties.fillOpacity = 1;
          hoverState.properties.tension = 0.4;

          chart.cursor = new am4charts.XYCursor();

          series.columns.template.adapter.add("fill", function (fill, target) {
            return chart.colors.getIndex(target.dataItem.index);
          });

          chart.scrollbarX = new am4core.Scrollbar();
        });

        am4core.ready(function () {

          am4core.useTheme(am4themes_animated);

          var chart = am4core.create("chartdiv1", am4charts.PieChart);

          var pieSeries = chart.series.push(new am4charts.PieSeries());
          pieSeries.dataFields.value = "total";
          pieSeries.dataFields.category = "sex";

          chart.innerRadius = am4core.percent(30);

          pieSeries.slices.template.stroke = am4core.color("#fff");
          pieSeries.slices.template.strokeWidth = 2;
          pieSeries.slices.template.strokeOpacity = 1;
          pieSeries.slices.template
            .cursorOverStyle = [
            {
              "property": "cursor",
              "value": "pointer"
            }
          ];

          pieSeries.alignLabels = false;
          pieSeries.labels.template.bent = true;
          pieSeries.labels.template.radius = 3;
          pieSeries.labels.template.padding(0, 0, 0, 0);

          pieSeries.ticks.template.disabled = true;

          var shadow = pieSeries.slices.template.filters.push(new am4core.DropShadowFilter);
          shadow.opacity = 0;

          var hoverState = pieSeries.slices.template.states.getKey("hover");

          var hoverShadow = hoverState.filters.push(new am4core.DropShadowFilter);
          hoverShadow.opacity = 0.7;
          hoverShadow.blur = 5;

          chart.legend = new am4charts.Legend();

          chart.data = res.user_hash;
        });

        am4core.ready(function () {

          am4core.useTheme(am4themes_animated);

          var chart = am4core.create("chartdiv2", am4charts.PieChart);

          var pieSeries = chart.series.push(new am4charts.PieSeries());
          pieSeries.dataFields.value = "count";
          pieSeries.dataFields.category = "category";

          chart.innerRadius = am4core.percent(30);

          pieSeries.slices.template.stroke = am4core.color("#fff");
          pieSeries.slices.template.strokeWidth = 2;
          pieSeries.slices.template.strokeOpacity = 1;
          pieSeries.slices.template
            .cursorOverStyle = [
            {
              "property": "cursor",
              "value": "pointer"
            }
          ];

          pieSeries.alignLabels = false;
          pieSeries.labels.template.bent = true;
          pieSeries.labels.template.radius = 3;
          pieSeries.labels.template.padding(0, 0, 0, 0);

          pieSeries.ticks.template.disabled = true;

          var shadow = pieSeries.slices.template.filters.push(new am4core.DropShadowFilter);
          shadow.opacity = 0;

          var hoverState = pieSeries.slices.template.states.getKey("hover");

          var hoverShadow = hoverState.filters.push(new am4core.DropShadowFilter);
          hoverShadow.opacity = 0.7;
          hoverShadow.blur = 5;

          chart.legend = new am4charts.Legend();

          chart.data = res.group_hash

        });

        am4core.ready(function () {

          am4core.useTheme(am4themes_animated);

          var chart = am4core.create("chartdiv3", am4charts.PieChart);

          var pieSeries = chart.series.push(new am4charts.PieSeries());
          pieSeries.dataFields.value = "count";
          pieSeries.dataFields.category = "category";

          chart.innerRadius = am4core.percent(30);

          pieSeries.slices.template.stroke = am4core.color("#fff");
          pieSeries.slices.template.strokeWidth = 2;
          pieSeries.slices.template.strokeOpacity = 1;
          pieSeries.slices.template
            .cursorOverStyle = [
            {
              "property": "cursor",
              "value": "pointer"
            }
          ];

          pieSeries.alignLabels = false;
          pieSeries.labels.template.bent = true;
          pieSeries.labels.template.radius = 3;
          pieSeries.labels.template.padding(0, 0, 0, 0);

          pieSeries.ticks.template.disabled = true;

          var shadow = pieSeries.slices.template.filters.push(new am4core.DropShadowFilter);
          shadow.opacity = 0;

          var hoverState = pieSeries.slices.template.states.getKey("hover");

          var hoverShadow = hoverState.filters.push(new am4core.DropShadowFilter);
          hoverShadow.opacity = 0.7;
          hoverShadow.blur = 5;

          chart.legend = new am4charts.Legend();

          chart.data = res.product_hash;

        });
      }
    });
  }
});