<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prog.kiev.ua</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
</head>

<body>
<div class="container">
    <h3><img height="50" width="55" src="<c:url value="/static/logo.png"/>"/><a href="/">Contacts List</a></h3>

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul id="groupList" class="nav navbar-nav">
                    <li>
                        <button type="button" id="add_contact" class="btn btn-default navbar-btn">Add Contact</button>
                    </li>
                    <li>
                        <button type="button" id="add_group" class="btn btn-default navbar-btn">Add Group</button>
                    </li>
                    <li>
                        <button type="button" id="delete_contact" class="btn btn-default navbar-btn">Delete Contact
                        </button>
                    </li>
                    <li>
                        <button type="button" class="btn btn-default navbar-btn" data-toggle="modal"
                                data-target="#myModal">Delete Group
                        </button>
                    </li>
                    <li>
                        <button type="button" class="btn btn-default navbar-btn" data-toggle="modal"
                                data-target="#upload">Upload from JSON
                        </button>
                    </li>
                    <li>
                        <button type="button" id="reset" class="btn btn-default navbar-btn">Reset</button>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                           aria-expanded="false">Groups <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="/">Default</a></li>
                            <c:forEach items="${groups}" var="groups">
                                <li><a href="/group/${groups.id}">${groups.name}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </ul>
                <form class="navbar-form navbar-left" role="search" action="/search" method="post">
                    <div class="form-group">
                        <input type="text" class="form-control" name="pattern" placeholder="Search">
                    </div>
                    <button type="submit" class="btn btn-default">Submit</button>
                </form>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Удаление группы</h4>
                </div>
                <div class="modal-body">
                    <p>При удалении группы все контакты в этой группе без возвратно удалятся!</p>
                    <div class="form-group">
                        <label for="select-group-id">Выберите группу для удаления:</label>
                        <select class="form-control" id="select-group-id">
                            <c:forEach items="${groups}" var="group">
                                <option value="${group.id}">${group.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
                    <button type="button" class="btn btn-primary" id="btn-accept">Подтвердить</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="upload" tabindex="-1" role="dialog" aria-labelledby="file-modal-label"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="file-modal-label">Загрузка файла JSON с контактами</h5>
                </div>
                <div class="modal-body">
                    <p>Все контакты с файла загрузятся в выбранную группу. Загрузка файла доступна в формате .txt</p>
                    <form id="file-upload-form" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="fileInput" class="form-label">Файл</label>
                            <input type="file" class="form-control-file" id="fileInput" name="fileInput" accept=".txt">
                        </div>
                        <div class="mb-3">
                            <label for="selectGroupIdUpload" class="form-label">Группа</label>
                            <select class="form-control" id="selectGroupIdUpload" name="selectGroupIdUpload">
                                <option value="-1">Default</option>
                                <c:forEach items="${groups}" var="group">
                                    <option value="${group.id}">${group.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Отмена</button>
                    <button type="button" class="btn btn-primary" id="file-upload-button">Загрузить</button>
                </div>
            </div>
        </div>
    </div>

    <table class="table table-striped">
        <thead>
        <tr>
            <td></td>
            <td><b>Name</b></td>
            <td><b>Surname</b></td>
            <td><b>Phone</b></td>
            <td><b>E-mail</b></td>
            <td><b>Group</b></td>
        </tr>
        </thead>
        <c:forEach items="${contacts}" var="contact">
            <tr>
                <td><input type="checkbox" name="toDelete[]" value="${contact.id}" id="checkbox_${contact.id}"/></td>
                <td>${contact.name}</td>
                <td>${contact.surname}</td>
                <td>${contact.phone}</td>
                <td>${contact.email}</td>
                <c:choose>
                    <c:when test="${contact.group ne null}">
                        <td>${contact.group.name}</td>
                    </c:when>
                    <c:otherwise>
                        <td>Default</td>
                    </c:otherwise>
                </c:choose>
            </tr>
        </c:forEach>
    </table>

    <nav aria-label="Page navigation">
        <ul class="pagination">
            <c:if test="${allPages ne null}">
                <c:forEach var="i" begin="1" end="${allPages}">
                    <li><a href="/?page=<c:out value="${i - 1}"/>"><c:out value="${i}"/></a></li>
                </c:forEach>
            </c:if>
            <c:if test="${byGroupPages ne null}">
                <c:forEach var="i" begin="1" end="${byGroupPages}">
                    <li><a href="/group/${groupId}?page=<c:out value="${i - 1}"/>"><c:out value="${i}"/></a></li>
                </c:forEach>
            </c:if>
        </ul>
    </nav>
</div>

<script>
    $('.dropdown-toggle').dropdown();

    $('#add_contact').click(function () {
        window.location.href = '/contact_add_page';
    });

    $('#add_group').click(function () {
        window.location.href = '/group_add_page';
    });

    $('#reset').click(function () {
        window.location.href = '/reset';
    });

    $('#delete_contact').click(function () {
        var data = {'toDelete[]': []};
        $(":checkbox:checked").each(function () {
            data['toDelete[]'].push($(this).val());
        });
        $.post("/contact/delete", data, function (data, status) {
            window.location.reload();
        });
    });

    $('#btn-accept').click(function () {
        var selectedOption = $('#select-group-id').val();
        $.post('/group/delete', {selectedOption: selectedOption})
            .done(function () {
                $('#btn-accept').removeClass('btn-primary').addClass('btn-success').text('Успешно');
                setTimeout(function () {
                    $('#myModal').modal('hide');
                    location.reload();
                }, 3000);
            })
            .fail(function () {
                $('#btn-accept').removeClass('btn-primary').addClass('btn-danger').text('Ошибка');
                setTimeout(function () {
                    $('#myModal').modal('hide');
                }, 3000);
            });
    });

    $(document).ready(function () {
        $('#file-upload-button').on('click', function () {
            var formData = new FormData($('#file-upload-form')[0]);
            $.ajax({
                url: '/contact/upload',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    $('#file-upload-button').removeClass('btn-primary').addClass('btn-success').text('Успешно');
                    setTimeout(function () {
                        $('#upload').modal('hide');
                        location.reload();
                    }, 3000);
                },
                error: function (response) {
                    $('#file-upload-button').removeClass('btn-primary').addClass('btn-danger').text('Ошибка');
                    setTimeout(function () {
                        $('#upload').modal('hide');
                    }, 3000);
                }
            });
        });
    });
</script>
</body>
</html>