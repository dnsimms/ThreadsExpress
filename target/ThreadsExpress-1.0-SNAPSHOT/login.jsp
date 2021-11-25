
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
  <title>Login - ThreadsExpress</title>
  <link rel="stylesheet" href="bootstrap.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:400,400i,700,700i,600,600i">
  <link rel="stylesheet" href="simple-line-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.css">
  <link rel="stylesheet" href="vanilla-zoom.min.css">
</head>

<%
  String username = "";
  String password = "";
  //make a variable to handle when the user is an admin
  String dbURL = "jdbc:mysql://localhost:3306/threadsexpress?serverTimezone=EST";
  String dbUser = "root";
  String dbPass = "G97t678!";
  Connection connection = null;

  try{
    connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
    if(request.getParameter("username") != null){//asdasd
      String userQuery = "SELECT username, password, title FROM employees ";//select all users, passes/work titles
      PreparedStatement prep1 = connection.prepareStatement(userQuery);
      ResultSet results = prep1.executeQuery(userQuery);
      boolean exists = false; //will keep track of if user is registered/found
      while(results.next()){
        if(request.getParameter("username").equals(results.getString(1))){//if user is found
          if(request.getParameter("password").equals(results.getString(2))){
            exists = true; %>
              <form class="login-form" id="loginForm" method="post" action=<%if(results.getString(3).equalsIgnoreCase("Stock Manager")){
              System.out.println("WORKING!!!");%>"inventory.jsp">
              <%}else{%>//admin page><%}%>
                <input type="hidden" id="currentUser" class="form-input" value= <%=results.getString(1)%>/>
                <input type="hidden" id="currentUserTitle" class="form-input" value= <%=results.getString(3)%>/>
              </form>
              <script>
                document.getElementById("loginForm").submit();
              </script>
<%
          }
        }
      }if(!exists){ %>
        <script>
          alert("Try Again.");
        </script>

      <% }

    }


%>

<body>
<nav class="navbar navbar-light navbar-expand-lg fixed-top bg-white clean-navbar">
  <div class="container"><a class="navbar-brand logo" href="#">ThreadsExpress</a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
    <div class="collapse navbar-collapse" id="navcol-1">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="index.html">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="about-us.html">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="contact-us.html">INVEntory</a></li>
        <li class="nav-item"><a class="nav-link active" href="login.html">Login</a></li>
      </ul>
      <ul class="navbar-nav"></ul>
    </div>
  </div>
</nav>
<main class="page login-page">
  <section class="clean-block clean-form dark">
    <div class="container">
      <div class="block-heading">
        <h2 class="text-info">Log In</h2>
        <p>Please sign in with your username and password.</p>
      </div>
      <form class="input-form" action="/ThreadsExpress_war_exploded/login.jsp" method="post">
        <div class="mb-3">
            <label class="form-label" for="username">Username</label>
            <input class="form-input" type="text" placeholder="username" id="username" name="username" required/>
        </div>
        <div class="mb-3"><label class="form-label" for="password">Password</label><input class="form-input" type="password" name="password" id="password" required/></div>
        <button class="btn btn-primary" type="submit">Log In</button>
      </form>
    </div>
  </section>
</main>
<footer class="page-footer dark">
  <div class="footer-copyright">
    <p>© 2021 Copyright ThreadsExpress</p>
  </div>
</footer>
<script src="bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.js"></script>
<script src="vanilla-zoom.js"></script>
<script src="theme.js"></script>
</body>
<%
  }catch (SQLException e){
    e.printStackTrace();
  }
%>
</html>