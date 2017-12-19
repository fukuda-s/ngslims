{{ content() }}

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
