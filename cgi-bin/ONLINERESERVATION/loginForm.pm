$currDir = `pwd`;
$currDir = "";

print <<"HTML";
<!-----------  LOGIN-FORM --------------->
  <div class="container">
  <div class="login">
  	<h1 class="login-heading">
      <strong>Login</strong> here</h1>
      
        <input type="text" id="user" name="user" placeholder="User" required="required" class="input-txt" value="$currDir"/>
          <input type="password" id="pw"  name="password" placeholder="Password" required="required" class="input-txt" />
          <div class="login-footer">
            <button id="send" class="btn btn--left">Sign in  </button>
    
          </div>
      
  </div>
</div>

<script  src="../simple-login-form/js/index.js"></script>

HTML
