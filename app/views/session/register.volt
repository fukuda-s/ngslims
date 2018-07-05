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
  <h2>Register for ngsLIMS</h2>
</div>

{{ form('session/register', 'id': 'registerForm', 'class': 'form-horizontal', 'onbeforesubmit': 'return false') }}
<fieldset>
  <div class="control-group">
    <label class="control-label" for="firstname">Your First Name</label>

    <div class="controls">
      {{ text_field('firstname', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="firstname_alert">
        <strong>Warning!</strong> Please enter your first name
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="lastname">Your Last Name</label>

    <div class="controls">
      {{ text_field('lastname', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="lastname_alert">
        <strong>Warning!</strong> Please enter your last name
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="username">Username</label>

    <div class="controls">
      {{ text_field('username', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="username_alert">
        <strong>Warning!</strong> Please enter your desired user name
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="email">Email Address</label>

    <div class="controls">
      {{ email_field('email', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="email_alert">
        <strong>Warning!</strong> Please enter your email
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="password">Password</label>

    <div class="controls">
      {{ password_field('password', 'class': 'input-xlarge') }}
      <p class="help-block">(minimum 8 characters)</p>

      <div class="alert" id="password_alert">
        <strong>Warning!</strong> Please provide a valid password
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="repeatPassword">Repeat Password</label>

    <div class="controls">
      {{ password_field('repeatPassword', 'class': 'input-xlarge') }}
      <div class="alert" id="repeatPassword_alert">
        <strong>Warning!</strong> The password does not match
      </div>
    </div>
  </div>
  <p>By signing up, you accept terms of use and privacy policy.</p>

  <div class="form-actions">
    {{ submit_button('Register', 'class': 'btn btn-primary btn-large', 'onclick': 'return SignUp.validate();') }}
  </div>
</fieldset>
</form>
