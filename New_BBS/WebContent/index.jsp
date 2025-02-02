<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.text.*,java.sql.Statement,java.io.*,com.BBS.*"%>

<%!
private void tree(Set<Article> articles,Connection conn,int id,int grade) { 
	String sql="select * from article conn where pid="+id;
	Statement stmt=DB.createStmt(conn);
	ResultSet rs=DB.executeQuery(stmt, sql);
	try{
		while(rs.next()){
			Article a=new Article();
			a.setId(rs.getInt("id"));
			a.setPid(rs.getInt("pid"));
			a.setRootId(rs.getInt("rootid"));
			a.setTitle(rs.getString("title"));
			a.setLeaf(rs.getInt("isleaf")==0?true:false);
			a.setPdate(rs.getDate("pdate"));
			a.setAuthor(rs.getString("author"));
			a.setGrade(grade);
			articles.add(a);
			if(!a.isLeaf()){
				tree(articles,conn,a.getId(),grade+1);
			}
			
		}
	}catch(SQLException e){
		e.printStackTrace();
	}
	
}

%>

<%
Set<Article> articles=new HashSet<Article>();
Connection conn=DB.getCon();
tree(articles,conn,0,0);
DB.close(conn);
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <title>BBS论坛</title>
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/index.css">

    <script>
        function zebra(aA) {
            var aA=aA;
            for(var i=0;i<aA.length;i++){
                i%2?aA[i].style.background='#eee':aA[i].style.background="";
            }

        }
        //筛选已回答帖子
        function Answered() {
             var oBtn=document.getElementsByTagName('input');
             for(var i=0;i<oBtn.length;i++){
                 oBtn[i].style.background='';
             }
             oBtn[2].style.background='#b9d3ee';
            var k=0;
            var aA=new Array();
            var cTab = document.getElementsByClassName('table_content');

            for (var i = 0; i < cTab.length; i++) {
                cTab[i].style.display = 'table-row';
                if (cTab[i].getElementsByClassName('tc')[2].innerHTML == 0) {
                    cTab[i].style.display = 'none';
                }
                else{aA[k]= cTab[i];k++;}
            }

            // if(oBtn.onclick)
            FilterSearch(aA);
            zebra(aA);
        }
        //筛选未回答帖子
        function Unanswered() {
            var oBtn=document.getElementsByTagName('input');
            for(var i=0;i<oBtn.length;i++){
                oBtn[i].style.background='';
            }
            oBtn[3].style.background='#b9d3ee';
            var k=0;
            var aA=new Array();
            var cTab = document.getElementsByClassName('table_content');
            for (var i = 0; i < cTab.length; i++) {
                cTab[i].style.display = 'table-row';
                if (cTab[i].getElementsByClassName('tc')[2].innerHTML != 0) {
                    cTab[i].style.display = 'none';
                }
                else{aA[k]= cTab[i];k++;}
            }
            FilterSearch(aA);
            zebra(aA)
        }
        //在筛选后的帖子中查找
        function FilterSearch(aA) {

            var oBtn = document.getElementById('btn1');
            var aA = aA;
            //alert(aA.length);
            var cTab = document.getElementsByClassName('table_content');
            oBtn.onclick = function () {
                cTab = aA;
                // alert(123);
                var oTxt = document.getElementById('title');
                for (var i = 0; i < cTab.length; i++) {
                    var oTable = cTab[i].getElementsByTagName('a')[0].innerHTML.toLowerCase();
                    var cTxt = oTxt.value.toLowerCase();
                    var arr = cTxt.split(' ');
                    cTab[i].style.display = 'none';
                    for (var j = 0; j < arr.length; j++) {
                        if (oTable.search(arr[j]) != -1) {
                            cTab[i].style.display = 'table-row';
                        }
                    }
                }
            }
        }
        //在未筛选的页面查找
        function Search() {
                var cTab = document.getElementsByClassName('table_content');
                    var oTxt=document.getElementById('title');
                    for(var i=0;i<cTab.length;i++) {
                        var oTable = cTab[i].getElementsByTagName('a')[0].innerHTML.toLowerCase();
                        var cTxt = oTxt.value.toLowerCase();
                        var arr = cTxt.split(' ');
                        cTab[i].style.display = 'none';
                        for (var j = 0; j < arr.length; j++) {
                            if (oTable.search(arr[j]) != -1) {
                                cTab[i].style.display = 'table-row';
                            }
                        }
                    }
            }
    </script>

</head>
<body>
<div class="top">
    <div class="top_in">
        <div class="top_left">
            <h1>
                <a href="#" title="BBS">
                    <image src="images/Logo1.png" ></image>
                    <span class="top_logo">BBS</span>
                </a>

            </h1>
        </div>
        <div class="top_right">
            <ul class="top_nav">
                <li><a href="#">首页</a></li>
                <li><a href="#">博客</a></li>
                <li><a href="#">学院</a></li>
                <li><a href="#">下载</a></li>
                <li><a href="#">GitChat</a></li>
                <li><a href="#">TinyMind</a></li>
            </ul>
            <ul class="top_login">
                <li><a href="#">登录</a></li>
                <li><a href="#">注册</a></li>
                <li><img src="images/Pangxie.png"></img></li>
            </ul>
        </div>
    </div>
</div>


<div class="banner">
    <div class="nav_out">
        <div class="nav">
            <ul>
                <li><a href="#"><p>论坛首页</p></a></li>
                <li><a href="#"><p>精选板块</p></a></li>
                <li><a href="#"><p>校园牛人</p></a></li>
                <li><a href="#"><p>校园新鲜事</p></a></li>
                <li><a href="#"><p>教师问答</p></a></li>
                <li><a href="#"><p>我要发帖</p></a></li>
            </ul>
        </div>
    </div>
</div>

<div class="page_nav">
    <div class="fr">
        <input type="text" id="title"  />
        <input id="btn1" type="button" value="搜索"  onclick="Search()"/>
        <input id="btn2" type="button" value="已回答" onclick="Answered()"  />
        <input id="btn3" type="button" value="未回答" onclick="Unanswered()"  />
        <a href="javascript:void(0)" onclick="window.location.reload()" class="btn_2">
        <span>刷新</span>
    </a>

</div>
    <ul>
    <li class="select_other"><a href="#" class="other">首页</a></li>
    <li class="select"><a href="#" >1</a></li>
    <li class="select"><a href="#" >2</a></li>
    <li class="select"><a href="#" >3</a></li>
    <li class="select"><a href="#" >4</a></li>
    <li class="select"><a href="#" >5</a></li>
    <li class="select"><a href="#" >6</a></li>
    <li class="page gap">...</li>
    <li class="select_other"><a href="#" class="other">下一页</a></li>
    <li class="select_other"><a href="#" class="other">尾页</a></li>
    <li><span>总数：5000，</span><span>共100页</span></li>
</ul>
    <div class="content">
        <table class="tab1" width="100%" border="0" cellpadding="0" cellspacing="0" >
            <colgroup>
                <col>
                <col width="60px">
                <col width="120px">
                <col width="60px">
                <col width="120px">
                <col width="60px">
            </colgroup>
          <tbody >
            <tr class="table_top">
                <th>标题</th>
                <th class="tc">分数</th>
                <th class="tc">提问人</th>
                <th class="tc">回复数</th>
                <th class="tc">最后更新时间</th>
                <th class="tc">功能</th>
            </tr>
            <%
            for(Iterator<Article> it=articles.iterator();it.hasNext();){
            	Article a=it.next();
            	String preStr="";
            	
            %>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" class="title_style_red title_style_bold" target="_blank" title="【新手提问导读】提问的艺术"><%=a.getTitle() %></a>
        
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">100</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="执笔记忆的空白"><%=a.getAuthor() %></a><br>
                    <span class="time"><%=a.getPdate()%>
                    </span></td>
                <td class="tc">0</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:32</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <%
            }
            %>
            <!-- <tr class="table_content"  >
                <td class="title">
                    <strong class="green"  >？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" target="_blank" title="大数据、AI、Python哪个才是2018最赚钱的语言？">大数据、AI、Python哪个才是2018最赚钱的语言？</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">50</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="HXDHXD1">HXDHXD1</a><br>
                    <span class="time">2018-05-10 14:42</span></td>
                <td class="tc">0</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:33</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" target="_blank" title="科大讯飞AIUI3.0发布会邀您见证人工智能盛事">科大讯飞AIUI3.0发布会邀您见证人工智能盛事</a>
                    <span class="red">[推荐]</span>
                    <span class="forum_link">[<span class="parent"><a href="#">硬件/嵌入开发</a></span> <a href="https://bbs.csdn.net/forums/SmartHardware">智能硬件</a>]</span>
                </td>
                <td class="tc">50</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="CSDNhanrui">CSDNhanrui</a><br>
                    <span class="time">2018-05-14 11:16</span></td>
                <td class="tc">11</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:33</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" class="title_style_red title_style_bold" target="_blank" title="【新手提问导读】提问的艺术">【新手提问导读】提问的艺术</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">100</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="执笔记忆的空白">执笔记忆的空白</a><br>
                    <span class="time">2018-05-03 12:04</span></td>
                <td class="tc">8</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:32</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" class="title_style_red title_style_bold" target="_blank" title="【新手提问导读】提问的艺术">【新手提问导读】提问的艺术</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">100</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="执笔记忆的空白">执笔记忆的空白</a><br>
                    <span class="time">2018-05-03 12:04</span></td>
                <td class="tc">8</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:32</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" class="title_style_red title_style_bold" target="_blank" title="【新手提问导读】提问的艺术">【新手提问导读】提问的艺术</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">100</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="执笔记忆的空白">执笔记忆的空白</a><br>
                    <span class="time">2018-05-03 12:04</span></td>
                <td class="tc">8</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:32</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content"  >
                <td class="title">
                    <strong class="green"  >？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" target="_blank" title="AI">AI</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">50</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="HXDHXD1">HXDHXD1</a><br>
                    <span class="time">2018-05-10 14:42</span></td>
                <td class="tc">0</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:33</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content"  >
                <td class="title">
                    <strong class="green"  >？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" target="_blank" title="大数据、AI、Python哪个才是2018最赚钱的语言？">大数据、AI、Python哪个才是2018最赚钱的语言？</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">50</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="HXDHXD1">HXDHXD1</a><br>
                    <span class="time">2018-05-10 14:42</span></td>
                <td class="tc">1</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:33</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr>
            <tr class="table_content">
                <td class="title">
                    <strong class="green">？</strong>
                    <span class="green">[置顶]</span>
                    <a href="#" class="title_style_red title_style_bold" target="_blank" title="提问的艺术">提问的艺术</a>
                    <span class="forum_link">[<span class="parent"><a href="#">Java</a></span> <a href="#">Java EE</a>]</span>
                </td>
                <td class="tc">100</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="执笔记忆的空白">执笔记忆的空白</a><br>
                    <span class="time">2018-05-03 12:04</span></td>
                <td class="tc">8</td>
                <td class="tc">
                    <a href="#" rel="nofollow" target="_blank" title="当年的春天">当年的春天</a><br>
                    <span class="time">2018-05-21 22:32</span>
                </td>
                <td class="tc">
                    <a href="#" target="_blank">管理</a>
                </td>
            </tr> -->
           
          </tbody>
        </table>
    </div>


</div>



</div>
</body>
</html>