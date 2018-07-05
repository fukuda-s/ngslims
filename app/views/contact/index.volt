{{ content() }}

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

<div class="page-header">
  <h2>Contact Us</h2>
</div>

<p>Send us a message and let us know how we can help. Please be as descriptive as possible as it will help us serve you
  better.</p>

{{ form('contact/send', 'class': 'form-horizontal') }}
<fieldset>
  <div class="control-group">
    <label class="control-label" for="name">Your Full Name</label>

    <div class="controls">
      {{ text_field('name', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="email">Email Address</label>

    <div class="controls">
      {{ text_field('email', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="comments">Comments</label>

    <div class="controls">
      {{ text_area('comments', 'rows': '5', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>
    </div>
  </div>
  <div class="form-actions">
    {{ submit_button('Send', 'class': 'btn btn-primary btn-large') }}
  </div>
</fieldset>
</form>
