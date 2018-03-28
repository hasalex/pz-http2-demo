<%@ page import="javax.servlet.http.PushBuilder" %>

<%    
    PushBuilder pushBuilder = request.newPushBuilder();
    if (pushBuilder != null) {
        pushBuilder.path("/main.css").push();
        pushBuilder.path("/empty.png").push();    
    }
 %>

<%@include  file="dino.html" %>
