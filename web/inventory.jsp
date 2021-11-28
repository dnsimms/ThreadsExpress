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

        String inventory = "SELECT * FROM inventory ";
        PreparedStatement prepInventory = connection.prepareStatement(inventory, ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet inventoryResults = prepInventory.executeQuery();



        if(request.getParameter("addNewItemButton") != null){
            //change archived from no to n
            int barcode = Integer.parseInt(request.getParameter("newBarcode"));
            int qty = Integer.parseInt(request.getParameter("newItemQuantity"));
            double itemPrice = Double.parseDouble(request.getParameter("newItemPrice"));
            String addItemQuery = "INSERT INTO inventory (barcode, quantity, price, color, product_name, size, clothing_type, archived, eid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ";
            PreparedStatement addItem_stmt = connection.prepareStatement(addItemQuery);
            addItem_stmt.setInt(1, barcode);
            addItem_stmt.setInt(2, qty);
            addItem_stmt.setDouble(3, itemPrice);
            addItem_stmt.setString(4, request.getParameter("newItemColor"));
            addItem_stmt.setString(5, request.getParameter("newItemTitle"));
            addItem_stmt.setString(6, request.getParameter("newItemSize"));
            addItem_stmt.setString(7, request.getParameter("newItemType"));
            addItem_stmt.setString(8, request.getParameter("newArchiveValue"));
            addItem_stmt.setString(9, request.getParameter("employeeID"));
            addItem_stmt.executeUpdate();

            System.out.println("Inserted into the database");
        }



%>

<body><nav class="navbar navbar-light navbar-expand-lg fixed-top bg-white clean-navbar">
    <div class="container"><a class="navbar-brand logo" href="#">ThreadsExpress</a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navcol-1">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.html">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="about-us.html">About Us</a></li>
                <li class="nav-item"><a class="nav-link" href="/ThreadsExpress_war_exploded/inventory.jsp">Inventory</a></li>
                <li class="nav-item"><a class="nav-link" href="login.html">Login</a></li>
            </ul>
            <ul class="navbar-nav"></ul>
        </div>
    </div>
</nav>
<main class="page">
    <section class="clean-block features">
        <div class="container mb-3 mt-3">
            <% int invRows = 0;
                if(inventoryResults.last()){
                    invRows = inventoryResults.getRow();
                    inventoryResults.beforeFirst();
                }if(invRows != 0) { %>
            <div class="block-heading">
                <h2 class="text-info">Inventory</h2>
            </div>

            <table id="inventoryTable" class="table table-striped table-bordered" style="width:100%">
                <thead>
                <tr><th>Barcode</th>
                    <th>Quantity</th>
                    <th>Employee ID</th>
                    <th>Price</th>
                    <th>Color</th>
                    <th>Name</th>
                    <th>Size</th>
                    <th>Type</th>
                    <th>Archived</th>
                </tr></thead>
                <tbody>
                <% while(inventoryResults.next()) { %>
                <tr>
                    <td><%=inventoryResults.getInt(1)%></td>
                    <td><%=inventoryResults.getInt(2)%></td>
                    <td><%=inventoryResults.getInt(9)%></td>
                    <td>$<%=inventoryResults.getDouble(3)%></td>
                    <td><%=inventoryResults.getString(4)%></td>
                    <td><%=inventoryResults.getString(5)%></td>
                    <td><%=inventoryResults.getString(6)%></td>
                    <td><%=inventoryResults.getString(7)%></td>
                    <th><%=inventoryResults.getString(8)%></th>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% }%>
            <button type="button" data-toggle="modal" data-target="#addNewLine">
                Add New Item
            </button>

        </div>
    </section>

    <div class="modal fade" id="addNewLine" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="modalLabel">Add New Inventory Item</h4>
                    <button type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">X</span>
                    </button>
                </div>
                <form class="needs-validation input-form" action="/ThreadsExpress_war_exploded/inventory.jsp" method="post" novalidate>
                    <div class="modal-body">
                        <div class="container">
                            <div class="form-row">
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newItemTitle"><b>Item Name</b></label>
                                    <input type="text" id="newItemTitle" name="newItemTitle" class="form-control" required/>
                                    <div class="invalid-feedback">Invalid Item Name</div>
                                </div>
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newBarcode"><b>Barcode Number</b></label>
                                    <input type="text" id="newBarcode" name="newBarcode" class="form-control" pattern="[0-9]{8}" required/>
                                    <div class="invalid-feedback">Invalid barcode, please enter a valid 8-digit number</div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="newItemQuantity"><b>Quantity</b></label>
                                    <input type="text" id="newItemQuantity" name="newItemQuantity" class="form-control" pattern="[0-9][0-9]" required/>
                                    <div class="invalid-feedback">Invalid format, please enter a number </div>
                                </div>
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="newItemPrice"><b>Item Price</b></label>
                                    <input type="text" id="newItemPrice" name="newItemPrice" class="form-control" pattern="[0-9]+(\.[0-9][0-9]?)?" required/>
                                    <div class="invalid-feedback">Invalid price, please enter in x.xx format.</div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4 md-form">
                                    <label class="form-label" for="newItemColor"><b>Item Color</b></label>
                                    <input type="text" id="newItemColor" name="newItemColor" class="form-control" pattern="[A-Za-z]{1,}" required/>
                                    <div class="invalid-feedback">Invalid Item Color</div>
                                </div>
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newItemSize"><b>Item Size</b></label>
                                    <select class="form-control" id="newItemSize" name="newItemSize" data-width="100%">
                                        <option value="" selected disabled hidden>Size</option>
                                        <option value="onesize">Onesize</option>
                                        <option value="small">Small</option>
                                        <option value="medium">Medium</option>
                                        <option value="large">Large</option>
                                        <option value="xlarge">X-Large</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-5 md-form">
                                    <label class="form-label" for="newItemType"><b>Item Type</b></label>
                                    <select class="form-control" id="newItemType" name="newItemType" data-width="100%">
                                        <option value="" selected disabled hidden>Clothing Type</option>
                                        <option value="dresses">Dresses</option>
                                        <option value="hats">Hats</option>
                                        <option value="hoodies">Hoodies</option>
                                        <option value="glasses">Glasses</option>
                                        <option value="shirt">Shirt</option>
                                        <option value="pants">Pants</option>
                                        <option value="shoes">Shoes</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-3 md-form">
                                    <label class="form-label" for="newArchiveValue"><b>Archive</b></label>
                                    <select class="form-control" id="newArchiveValue" name="newArchiveValue" data-width="100%">
                                        <option value="n" selected>No</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-3 md-form">
                                    <label class="form-label" for="employeeID"><b>EID</b></label>
                                    <input type="text" id="employeeID" name="employeeID" class="form-control" pattern="[0-9]" required/>
                                    <div class="invalid-feedback">Enter a valid employee ID</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Exit</button>
                        <button type="submit" class="btn btn-primary" name="addNewItemButton">Add Item</button>
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
    $('#inventoryTable').DataTable();
</script>
</body>
<%
    }catch (SQLException e){
        e.printStackTrace();
    }
%>
</html>
