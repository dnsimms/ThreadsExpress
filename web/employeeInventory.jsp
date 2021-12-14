<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Inventory - ThreadsExpress</title>
    <link rel="stylesheet" href="bootstrap.min.css">
    <!-- <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css"> -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:400,400i,700,700i,600,600i">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.css">
    <link rel="stylesheet" href="vanilla-zoom.min.css">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.19.1/js/mdb.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.4/umd/popper.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.min.js"></script>

</head>

<%
    String dbURL = "jdbc:mysql://localhost:3306/threadsexpress?serverTimezone=EST";
    String dbUser = "root";
    String dbPass = "G97t678!";
    Connection connection = null;
    try{
        connection = DriverManager.getConnection(dbURL,dbUser,dbPass);

        String inventory = "SELECT * FROM employees ";
        PreparedStatement prepInventory = connection.prepareStatement(inventory, ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet employeeResults = prepInventory.executeQuery();
        if(request.getParameter("addNewEmployeeButton") != null){
            //change archived from no to n
            String addItemQuery = "INSERT INTO employees (name, title, username, password) VALUES (?, ?, ?, ?) ";
            PreparedStatement addItem_stmt = connection.prepareStatement(addItemQuery);
            addItem_stmt.setString(1, request.getParameter("newFullName"));
            addItem_stmt.setString(2, request.getParameter("newTitle"));
            addItem_stmt.setString(3, request.getParameter("newUsername"));
            addItem_stmt.setString(4, request.getParameter("newPass"));
            addItem_stmt.executeUpdate();
            System.out.println("Inserted into the database");
        }


        if(request.getParameter("editEmployeeButton") != null){
            //change archived from no to n
            int eid = Integer.parseInt(request.getParameter("eid"));
            boolean isFound = false;
            employeeResults.beforeFirst();
            while(employeeResults.next() && !isFound){
                if(eid == employeeResults.getInt(1)){
                    String editItemQuery = "UPDATE employees SET name = ?, title = ?, username = ?, password = ? WHERE eid = "+ eid;
                    PreparedStatement editItem_stmt = connection.prepareStatement(editItemQuery);
                    editItem_stmt.setString(1, request.getParameter("FullName"));
                    editItem_stmt.setString(2, request.getParameter("Title"));
                    editItem_stmt.setString(3, request.getParameter("Username"));
                    editItem_stmt.setString(4, request.getParameter("Pass"));
                    editItem_stmt.executeUpdate();
                    isFound = true;
                    employeeResults.beforeFirst();
                    System.out.println("Updated item in database");
                }else{%>
<script>
    alert("Employee ID not found!");
</script>
                        <%break;
                }
            }


        }



%>

<body><nav class="navbar navbar-light navbar-expand-lg fixed-top bg-white clean-navbar">
    <div class="container"><a class="navbar-brand logo" href="#">ThreadsExpress</a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navcol-1">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="about-us.html">About Us</a></li>
                <li class="nav-item"><a class="nav-link" href="/ThreadsExpress_war_exploded/adminInventory.jsp">Inventory</a></li>
                <li class="nav-item"><a class="nav-link" href="/ThreadsExpress_war_exploded/login.jsp">Logout</a></li>
            </ul>
            <ul class="navbar-nav"></ul>
        </div>
    </div>
</nav>
<main class="page">
    <section class="clean-block features">
        <div class="container mb-3 mt-3">
            <% int invRows = 0;
                if(employeeResults.last()){
                    invRows = employeeResults.getRow();
                    employeeResults.beforeFirst();
                }if(invRows != 0) { %>
            <div class="block-heading">
                <h2 class="text-info">Admin Inventory</h2>
            </div>
            <div class="dropdown mb-4">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Admin Controls
                </button>
                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                    <a class="dropdown-item" href="/ThreadsExpress_war_exploded/employeeInventory.jsp">Add New Employee</a>
                    <a class="dropdown-item" href="#">Another action</a>
                </div>
            </div>
            <table id="adminInventoryTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr><th>EID</th>
                    <th>Employee's Name</th>
                    <th>Employee Title</th>
                    <th>Username</th>
                    <th>Password</th>
                </tr></thead>
                <tbody>
                <% while(employeeResults.next()) { %>
                <tr>
                    <td><%=employeeResults.getInt(1)%></td>
                    <td><%=employeeResults.getString(2)%></td>
                    <td><%=employeeResults.getString(3)%></td>
                    <td><%=employeeResults.getString(4)%></td>
                    <td>******</td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% }%>
            <button type="button" data-toggle="modal" data-target="#addNewLine">
                Add New Employee
            </button>
            <button type="button" data-toggle="modal" data-target="#editModal">
                Edit Employee
            </button>

        </div>
    </section>

    <div class="modal fade" id="addNewLine" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="modalLabel">Add New Employee</h4>
                    <button type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">X</span>
                    </button>
                </div>
                <form class="needs-validation input-form" action="/ThreadsExpress_war_exploded/employeeInventory.jsp" method="post" novalidate>
                    <div class="modal-body">
                        <div class="container">
                            <div class="form-row">
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newFullName"><b>Full Name</b></label>
                                    <input type="text" id="newFullName" name="newFullName" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter first and last name</div>
                                </div>
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newTitle"><b>Inventory Role</b></label>
                                    <select class="form-control" id="newTitle" name="newTitle" data-width="100%">
                                        <option value="" selected disabled hidden>Inventory Role</option>
                                        <option value="dresses">Administrator</option>
                                        <option value="hats">Stock Manager</option>
                                        <option value="hoodies">Stock Employee</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="newUsername"><b>Username</b></label>
                                    <input type="text" id="newUsername" name="newUsername" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter employee username.</div>
                                </div>
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="newPass"><b>Password</b></label>
                                    <input type="text" id="newPass" name="newPass" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter a new password</div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Exit</button>
                        <button type="submit" class="btn btn-primary" name="addNewEmployeeButton">Add Employee</button>
                    </div>
                </form>
            </div>

        </div>
        <script type="text/javascript">
            (function() {
                'use strict';
                window.addEventListener('load', function() {
                    var forms = document.getElementsByClassName('needs-validation');
                    var validation = Array.prototype.filter.call(forms, function(form) {
                        form.addEventListener('submit', function(event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();

        </script>

    </div>

    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editmodalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="editmodalLabel">Edit Employee Info</h4>
                    <button type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">X</span>
                    </button>
                </div>
                <form class="needs-validation input-form" action="/ThreadsExpress_war_exploded/employeeInventory.jsp" method="post" novalidate>
                    <div class="modal-body">
                        <div class="container">
                            <div class="form-row">
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="FullName"><b>Full Name</b></label>
                                    <input type="text" id="FullName" name="FullName" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter first and last name</div>
                                </div>
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="Title"><b>Inventory Role</b></label>
                                    <select class="form-control" id="Title" name="Title" data-width="100%">
                                        <option value="" selected disabled hidden>Inventory Role</option>
                                        <option value="dresses">Administrator</option>
                                        <option value="hats">Stock Manager</option>
                                        <option value="hoodies">Stock Employee</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="Username"><b>Username</b></label>
                                    <input type="text" id="Username" name="Username" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter employee username.</div>
                                </div>
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="Pass"><b>Password</b></label>
                                    <input type="text" id="Pass" name="Pass" class="form-control" required/>
                                    <div class="invalid-feedback">Please enter a new password</div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="eid"><b>Current EID</b></label>
                                    <input type="text" id="eid" name="eid" class="form-control" pattern="[0-9]{1}" required/>
                                    <div class="invalid-feedback">Please enter the employee's current ID</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Exit</button>
                        <button type="submit" class="btn btn-primary" name="editEmployeeButton">Edit Employee</button>
                    </div>
                </form>
            </div>

        </div>
        <script type="text/javascript">
            (function() {
                'use strict';
                window.addEventListener('load', function() {
                    var forms = document.getElementsByClassName('check-validation');
                    var validation = Array.prototype.filter.call(forms, function(form) {
                        form.addEventListener('submit', function(event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();
            if(window.history.replaceState){
                window.history.replaceState(null, null, window.location.href);
            }
        </script>

    </div>
</main>
<footer class="page-footer dark">
    <div class="footer-copyright">
        <p>© 2021 Copyright ThreadsExpress</p>
    </div>
</footer>
<script src="bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/dataTables.bootstrap5.min.js"></script>
<script src="vanilla-zoom.js"></script>
<script src="theme.js"></script>
<script>
    $('#adminInventoryTable').DataTable();
</script>
</body>
<%
    }catch (SQLException e){
        e.printStackTrace();
    }
%>
</html>
