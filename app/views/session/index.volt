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

<div class="login-or-signup">
  <div class="row">

    <div class="col-sm-3">
      <div class="page-header">
        <h2>Log In</h2>
      </div>
      {{ form('session/start', 'role': 'form') }}
      <fieldset>

        <input type="hidden" name="<?php echo $this->security->getTokenKey() ?>"
               value="<?php echo $this->security->getToken() ?>"/>

        <div class="form-group">
          <label for="email">Username/Email</label>
          {{ text_field('email', 'size': "30", 'class': "form-control") }}
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          {{ password_field('password', 'size': "30", 'class': "form-control") }}
        </div>
        <div class="form-group">
          {{ submit_button('Login', 'class': 'btn btn-primary btn-large') }}
        </div>
      </fieldset>
      </form>
    </div>

    <!--
    <div class="col-md-6">
      <div class="page-header">
        <h2>Don't have an account yet?</h2>
      </div>

      <p>Create an account offers the following advantages:</p>
      <ul>
        <li>Create, track and export your invoices online</li>
        <li>Gain critical insights into how your business is doing</li>
        <li>Stay informed about promotions and special packages</li>
      </ul>

      <div class="clearfix center">
        {{ link_to('session/register', 'Sign Up', 'class': 'btn btn-primary btn-large btn-success') }}
      </div>
    </div>
    -->

  </div>
</div>
