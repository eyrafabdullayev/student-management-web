<%-- 
    Document   : index
    Created on : Oct 26, 2019, 2:37:35 PM
    Author     : eyraf
--%>

<%@page import="bean.StudentDatabase"%>
<%@page import="java.util.List"%>
<%@page import="bean.Student"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    //Get All Parameters
    String action = request.getParameter("action");

    String name = request.getParameter("name");
    name = name == null ? "" : name;
    String surname = request.getParameter("surname");
    surname = surname == null ? "" : surname;
    String ageStr = request.getParameter("age");
    ageStr = ageStr == null ? "" : ageStr;

    Integer age = null;
    if (ageStr != null && !ageStr.equals("")) {
        age = Integer.parseInt(ageStr);
    }

    List<Student> result = null;

    if (action != null && !action.isEmpty()) {

        String studentIdStr = request.getParameter("studentId");
        Integer studentId = null;
        if (studentIdStr != null && !studentIdStr.isEmpty()) {
            studentId = Integer.parseInt(studentIdStr);
        }

        if (action.equalsIgnoreCase("search")) {
            result = StudentDatabase.get(name, surname, age);
        } else if (action.equalsIgnoreCase("add")) {
            int res = StudentDatabase.insert(name, surname, age);
        } else if (action.equalsIgnoreCase("update")) {
            Student newStudent = new Student(studentId, name, surname, age);
            int res = StudentDatabase.update(newStudent);
        } else if (action.equalsIgnoreCase("delete")) {
            int res = StudentDatabase.delete(studentId);
        }
    }

    if ((action == null) || !action.equalsIgnoreCase("search")) {
        name = "";
        surname = "";
        age = null;
    }

    result = StudentDatabase.get(name, surname, age);
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

        <script>
            function studentIdForDelete(id) {
                document.getElementById("studentIdForDelete").value = id;
            }

            function studentIdForUpdate(id,name,surname,age) {
                document.getElementById("studentIdForUpdate").value = id;
                document.getElementById("updateName").value = name;
                document.getElementById("updateSurname").value = surname;
                document.getElementById("updateAge").value = age;
            }
        </script>

        <title>Student Management Web App  | JSP</title>

        <style>
            body{
                margin-top:40px;    
            }

            .form-group{
                width: 300px;
            }

            .container{
                margin-top:20px;     
            }

            .header{
                margin-top:20px;    
            }

            .content{
                margin-top:60px;    
            }

            .footer{
                margin-top:80px;    
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <form>
                    <div class="form-group">
                        <label for="age">Name</label>
                        <input type="text" class="form-control" name="name">
                    </div>
                    <div class="form-group">
                        <label for="surname">Surname</label>
                        <input type="text" class="form-control" name="surname">
                    </div>
                    <div class="form-group">
                        <label for="age">Age</label>
                        <input type="text" class="form-control" name="age">
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="add">Add</button>
                    <button type="submit" class="btn btn-secondary" name="action" value="search">Search</button>
                </form>
            </div>
            <div class="content">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Name</th>
                            <th scope="col">Surname</th>
                            <th scope="col">Age</th>
                            <th scope="col">Operations</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < result.size(); i++) { %>

                        <tr>
                            <th scope = "row" ><% out.print(i + 1);%> </th>
                            <td><%out.print(result.get(i).getName());%></td>
                            <td><%out.print(result.get(i).getSurname());%></td>
                            <td><%out.print(result.get(i).getAge());%></td>
                            <td>
                                <button type = "button" class="btn btn-primary"
                                        onclick ="studentIdForUpdate('<%out.print(result.get(i).getId());%>','<%out.print(result.get(i).getName());%>','<%out.print(result.get(i).getSurname());%>','<%out.print(result.get(i).getAge());%>')"
                                        data-toggle="modal" data-target="#updateModal">
                                    <i class="fa fa-wrench" aria-hidden="true"></i>
                                </button>
                                <button type="button" class="btn btn-danger"
                                        onclick="studentIdForDelete('<%out.print(result.get(i).getId());%>')"
                                        data-toggle="modal" data-target="#deleteModal">
                                    <i class="fa fa-trash" aria-hidden="true"></i>
                                </button>
                            </td>
                        </tr>

                        <% }%>
                    </tbody>
                </table>

                <!-- Modal -->
                <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <form>
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exampleModalLabel">Delete Student</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    Are you sure?
                                </div>
                                <div class="modal-footer">
                                    <input type="hidden" name="studentId" id="studentIdForDelete" />
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                                    <button type="submit" class="btn btn-primary" name="action" value="delete">Yes</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal -->
                <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <form>
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="age">Name</label>
                                        <input type="text" class="form-control" name="name" id="updateName">
                                    </div>
                                    <div class="form-group">
                                        <label for="surname">Surname</label>
                                        <input type="text" class="form-control" name="surname" id="updateSurname">
                                    </div>
                                    <div class="form-group">
                                        <label for="age">Age</label>
                                        <input type="text" class="form-control" name="age" id="updateAge">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <input type="hidden" name="studentId" id="studentIdForUpdate" />
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-primary" name="action" value="update">Save changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer">
                <h1 style="text-align: center;font-size:16px;font-family: arial">All rights reserved | <b>Eyraf Abdullayev</b></h1>
            </div>
        </div>    
    </body>
</html>
