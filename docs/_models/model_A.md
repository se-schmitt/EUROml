---
layout: page
title: Model A
---

# Model A

`success`{:.success}

## Stats

| Gruoup 1 |          |     |     |
|----------|----------|-----|-----|
| Germany  | Scotland | 5:1 | 3:1 |
| Swiss    | Hungary  |     |     |
| Germany  | Hungary  |     |     |

<ul>
{% for member in site.data.members %}
  <li>
    <a href="https://github.com/{{ member.github }}">
      {{ member.name }}
    </a>
  </li>
{% endfor %}
</ul>


<table>
  {% for row in site.data.members %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    <!-- {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %} -->

    <tr>
      <td>{{ row.name }}</td>
      <td>{{ row.github }}</td>
    </tr>
  {% endfor %}
</table>

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
    <table>
      {% for row in site.data.members %}
        {% if forloop.first %}
        <tr>
          {% for pair in row %}
            <th>{{ pair[0] }}</th>
          {% endfor %}
        </tr>
        {% endif %}
    
        <tr>
          <td>{{ row.name }}</td>
          <td>{{ row.github }}</td>
        </tr>
      {% endfor %}
    </table>

    <table>
      {% for row in site.data.members %}
        {% if forloop.first %}
        <tr>
          {% for pair in row %}
            <th>{{ pair[0] }}</th>
          {% endfor %}
        </tr>
        {% endif %}
    
        <tr>
          <td>{{ row.name }}</td>
          <td>{{ row.github }}</td>
        </tr>
      {% endfor %}
    </table>
  </div>
</body>
</html>
