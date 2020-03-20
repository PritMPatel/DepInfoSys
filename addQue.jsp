<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="Connection.Connect"%>
<%@page import="java.sql.ResultSetMetaData"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <title>ADD QUESTION</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <%-- <script src="js/jquery-3.2.1.min.js"></script> --%>
    </head>
    <body>
        <a href="addCo.jsp">Add CO</a><br/>
        <a href="addExam.jsp">Add Exam</a><br/>
        <a href="addQue.jsp">Add Question</a><br/>
        <a href="addMarks.jsp">Add Marks</a><br/>
        <a href="calculateAttainment.jsp">Calculate Attainment</a><br/>
        <br/><br/>
        <form method="POST">
            <div id="selectexam">
            SubjectID:<input type="number" name="subjectid"/><br/> 
            Batch:<input type="number" name="batch1"/><br/> 
            <button name="examselect" value="examselect">Select Exam</button><br/>
            </div>
            <%
                Connect con=null;
                ResultSet rs=null;
                ResultSet rs2=null;
                ResultSetMetaData mtdt=null;
                String s = "";
                con=new Connect();
                if(request.getParameter("examselect")!=null){
                        rs=con.SelectData("select * from exam_master where subjectID="+request.getParameter("subjectid")+" and batch="+request.getParameter("batch1")+";");
                        out.println("SubjectID:<input type='number' name='subject_id' value='"+request.getParameter("subjectid")+"'/><br/> ");
                        out.println("Batch:<input type='number' name='batch' value='"+request.getParameter("batch1")+"'/><br/> ");
                        out.println("ExamID:<select name='exam_id'><br/>");
                        while(rs.next()){
                            out.println("<option value='"+rs.getInt("examID")+"'>"+rs.getInt("examID")+" - "+rs.getString("examName")+"</option>");
                        }
                        out.println("</select></br>");
                    }  
            %>
            No of QUESTION:  <input type="number" name="qno" id="quNo"/>
            <input onclick="addRow(this.form);" type="button" name="addbut" value="Add"><br/>
            <%-- :::Question Normalized Max Marks Calculated From Multiply QuesMarks with exam_master nMaxMarks/MaxMarks:::<br/><br/>
            :::Question Weighted Max Marks Calculated From Multiply nQuesMarks with exam_master maxWeighMarks/nMaxMarks:::<br/><br/> --%>
            <div id="ques">
            </div>
            <button type="submit" name="submit" value="submit">Submit</button>
            <% 
            if(request.getParameter("submit")!=null){
                int qunos = Integer.parseInt(request.getParameter("qno"));
                ResultSet rs3 = con.SelectData("SELECT em.examID,em.examTypeID, em.weightage, em.totalMaxMarks, etm.percentWeight FROM exam_master em, examtype_master etm where em.examTypeID=etm.examTypeID and examID="+request.getParameter("exam_id")+";");
                float fetchWeight = 0;
                float fetchTotalMarks = 0;
                int examTypeID = 0;
                float percentWeight = 0;
                float calcQuesMaxMarks = 0;
                float nCalcQuesMaxMarks = 0;
                if(rs3.next()){
                fetchWeight = rs3.getFloat("weightage");
                fetchTotalMarks = rs3.getFloat("totalMaxMarks");
                examTypeID = rs3.getInt("examTypeID");
                percentWeight = rs3.getFloat("percentWeight");
                }
                int x=1;
                while(x<=qunos){
                    String coVal = "";
                    String coHead = "";
                    int m = Integer.parseInt(request.getParameter("map"+x));
                    float a = Float.parseFloat(request.getParameter("qMarks"+x))*fetchWeight;
                    float b = Float.parseFloat(request.getParameter("map"+x))*fetchTotalMarks;
                    calcQuesMaxMarks = a/b;
                    nCalcQuesMaxMarks = calcQuesMaxMarks*percentWeight;
                    
                    for(int i=1;i<=m;i++){
                        coHead = coHead + "coID"+ String.valueOf(i);
                        coVal = coVal + request.getParameter("qmap"+x+"co"+i);
                        if(i<m){
                            coHead += ",";
                            coVal += ",";
                        }
                    }

                    if(con.Ins_Upd_Del("insert into question_master(queDesc,queMaxMarks,multipleMap,calcQuesMaxMarks,nCalcQuesMaxMarks,examID,"+coHead+") values('"+request.getParameter("q"+x)+"',"+request.getParameter("qMarks"+x)+","+request.getParameter("map"+x)+","+calcQuesMaxMarks+","+nCalcQuesMaxMarks+","+request.getParameter("exam_id")+","+coVal+");")){
                        out.println("<script>alert('Question "+x+" inserted......');</script>");
                    }
                    else{
                        out.println("<script>alert('Question "+x+" was not inserted......');</script>");
                    }
                    x++;
                }
            }
            %>


        </form>
    </body>
    
    <script type="text/javascript">
        var st = '<%
            if(request.getParameter("examselect")!=null){
                    rs2=con.SelectData("select * from co_master where subjectID="+request.getParameter("subjectid")+";");
                    while(rs2.next()){
                        s = s +"<option value=\""+rs2.getInt("coID")+"\">CO "+rs2.getInt("coSrNo")+" - "+rs2.getString("coStatement")+"</option>";
                    }
                    out.print(s);
                }
        %>';
        var n=1;
        
        function addRow(frm) {
            var qno = frm.qno.value;
            while(n<=qno){
                console.log( "ready!" );
                var i=1;
                jQuery('#ques').append('\
                <div name="dQ'+n+'">\
                    Ques '+n+' Desc:<input type="text" name="q'+n+'"><br/>\
                    Ques '+n+' MaxMarks:<input type="number" name="qMarks'+(n)+'"><br/>\
                        MultipleMapping:<input class="multiMap" type="number" id="map'+n+'" name="map'+n+'">\
                        \
                        <div id="map'+n+'Co">\
                        </div></div><br/>');
                n++;
            }
            frm.addbut.disabled="true";
        }
        $(document).on("change",".multiMap",function(){
                    var i= document.getElementById(this.id+"Co");
                    var no = this.value;
                    var j=1;
                    $(i).text('');
                    while(j<=no){
                        $(i).append(j+' Co:<select name="q'+(this.id)+'co'+j+'">'+st+'</select><br/>');
                        j++;
                    }
        });

    </script>
</html>