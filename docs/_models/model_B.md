---
layout: page
title: Model B
---

# Model B

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Side by Side Tables</title>
  <style>
    .table-container {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(20px, 1fr));
      gap: 10px;
    }
    .table-container table {
      border-collapse: collapse;
      width: 100%;
    }
    .table-container th, .table-container td {
      border: 1px solid #ccc;
      padding: 4px;
      text-align: left;
    }
  </style>
</head>
<body>
  <div class="table-container">
    {% for group in site.groups %}
      <table>
        <tr>
          <th><p style="font-size:120%">Group {{group.name}}</p></th>
          <th></th>
          <th></th>
        </tr>
        <tr>
          <th>game</th>
          <th>result</th>
          <th>ML</th>
        </tr>
        {% for row in site.data.model_A.group{{group.name}} %}
          <tr>
            <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
            <td>{{row.result_home}}:{{row.result_away}}</td>
            <td><p color="{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
          </tr>
        {% endfor %}
      </table>
    {% endfor %}
  </div>
</body>
</html>