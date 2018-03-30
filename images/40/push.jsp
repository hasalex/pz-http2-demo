<%@ page import="javax.servlet.http.PushBuilder" %>
<%@ page import="java.text.NumberFormat" %>

<%    
    PushBuilder pushBuilder = request.newPushBuilder();
    if (pushBuilder != null) {
        System.out.println("-- Push enabled");
        pushBuilder.path("/main.css").push();
        pushBuilder.path("/empty.png").push();

        NumberFormat formatter = NumberFormat.getIntegerInstance();
        formatter.setMinimumIntegerDigits(3);
        for (int i = 0; i <= 300; i++) {
            pushBuilder.path("/rocket-" + formatter.format(i) + ".jpg").push();
        }
        // Nombre de push effectifs limité (196 ?)
        // Erreur lecture de réponse à 575
    } else {
        System.out.println("-- Push disabled");
    }
 %>

<%@include  file="index.html" %>
