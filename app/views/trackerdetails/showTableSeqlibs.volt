{% for seqlib in seqlibs %}
  {% if loop.first %}
    <!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

<table class="table table-bordered table-hover table-condensed table-responsive collapse in"
    id="seqtemplate-table-{{ seqlib.st.id }}" style="overflow: auto; font-size: 9pt;">
    <thead>
    <tr>
      <th>Project Name</th>
      <th>PI Name</th>
      <th>Seqlib Name</th>
      <th>Sample Name</th>
      <th>Index A</th>
      <th>Index A Seq</th>
      {% if oligobarcodeB_exists == true %}
        <th>Index B</th>
        <th>Index B Seq</th>
      {% endif %}
      <th>Protocol</th>
      <th>Required Seq Run Type</th>
    </tr>
    </thead>
    <tbody>
  {% endif %}
  <tr id="seqlib_id_{{ seqlib.sl.id }}">
    <td>{{ seqlib.p.name }}</td>
    {% if seqlib.u is empty %}
      <td>(Undefined PI)</td>
    {% else %}
      <td>{{ seqlib.u.getFullname() }}</td>
    {% endif %}
    <td>{{ seqlib.sl.name }}</td>
    <td>{{ seqlib.s.name }}</td>
    <td>{{ seqlib.sl.getOligobarcodeA().name }}</td>
    <td>{{ seqlib.sl.getOligobarcodeA().barcode_seq }}</td>
    {% if oligobarcodeB_exists == true %}
      {% if seqlib.sl.oligobarcodeB_id != null %}
        <td>{{ seqlib.sl.getOligobarcodeB().name }}</td>
        <td>{{ seqlib.sl.getOligobarcodeB().barcode_seq }}</td>
      {% else %}
        <td></td>
        <td></td>
      {% endif %}
    {% endif %}
    <td>{{ seqlib.pt.name }}</td>
    <td>{{ seqlib.it.name ~ ' ' ~ seqlib.srct.name ~ ' ' ~ seqlib.srrt.name ~ ' ' ~ seqlib.srmt.name }}</td>
  </tr>
  {% if loop.last %}
    </tbody>
    </table>
  {% endif %}
  {% elsefor %} No seqlib recorded
{% endfor %}
