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



%>

<body><nav class="navbar navbar-light navbar-expand-lg fixed-top bg-white clean-navbar">
    <div class="container"><a class="navbar-brand logo" href="#">ThreadsExpress</a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="navcol-1">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.html">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="about-us.html">About Us</a></li>
                <li class="nav-item"><a class="nav-link" href="inventory.html">Inventory</a></li>
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
        </div>
    </section>
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
