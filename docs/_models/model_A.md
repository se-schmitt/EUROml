---
layout: page
title: Model A
---

<!-- # Model A -->

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Side by Side Tables</title>
  <style>
    .table-container {
      display: grid;
      grid-template-columns:  repeat(3, 1fr);
      gap: 5px;
    }
    .table-container table {
      border-collapse: collapse;
      width: 100%;
    }
    .table-container th, .table-container td, .tb th, .tb td {
      border: 1px solid #ccc;
      padding: 4px;
      text-align: center;
    }
    .tb { 
      border-collapse: collapse; 
      width: 33%;
      margin-left: auto;
      margin-right: auto;
    }
  </style>
</head>
<body>

<h2>Group stage</h2>

  <div class="table-container">
    <!-- Group A -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group A</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupA %}
        <tr>
          <td><img src="/images/{{row.home_team}}.png"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
    <!-- Group B -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group B</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupB %}
        <tr>
          <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
    <!-- Group C -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group C</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupC %}
        <tr>
          <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
    <!-- Group D -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group D</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupD %}
        <tr>
          <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
    <!-- Group E -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group E</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupE %}
        <tr>
          <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
    <!-- Group F -->
    <table>
      <tr>
        <th><p style="font-size:120%">Group F</p></th>
        <th></th>
        <th></th>
      </tr>
      <tr>
        <th>game</th>
        <th>result</th>
        <th>ML</th>
      </tr>
      {% for row in site.data.model_A.groupF %}
        <tr>
          <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
          <td>{{row.result_home}}:{{row.result_away}}</td>
          <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
        </tr>
      {% endfor %}
    </table>
  </div>

<h2>Finals</h2>

<h3>Round of 16</h3>

  <table class="tb">
    <tr>
      <th>game</th>
      <th>result</th>
      <th>ML</th>
    </tr>
    {% for row in site.data.model_A.roundof16 %}
      <tr>
        <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
        <td>{{row.result_home}}:{{row.result_away}}</td>
        <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
      </tr>
    {% endfor %}
  </table>

<h3>Quarter Finals</h3>

  <table class="tb">
    <tr>
      <th>game</th>
      <th>result</th>
      <th>ML</th>
    </tr>
    {% for row in site.data.model_A.quarterfinals %}
      <tr>
        <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
        <td>{{row.result_home}}:{{row.result_away}}</td>
        <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
      </tr>
    {% endfor %}
  </table>

<h3>Semi Finals</h3>

  <table class="tb">
    <tr>
      <th>game</th>
      <th>result</th>
      <th>ML</th>
    </tr>
    {% for row in site.data.model_A.semifinals %}
      <tr>
        <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
        <td>{{row.result_home}}:{{row.result_away}}</td>
        <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
      </tr>
    {% endfor %}
  </table>

<h3>Final</h3>

  <table class="tb">
    <tr>
      <th>game</th>
      <th>result</th>
      <th>ML</th>
    </tr>
    {% for row in site.data.model_A.final %}
      <tr>
        <td><img src="/images/{{row.home_team}}.webp"> vs. <img src="/images/{{row.away_team}}.webp"></td>
        <td>{{row.result_home}}:{{row.result_away}}</td>
        <td><p style="color:{{row.color}}">{{row.pred_home}}:{{row.pred_away}}</p></td>
      </tr>
    {% endfor %}
  </table>

</body>
</html>

## Statistics

### Training 

![Training](/images/model_A.png)