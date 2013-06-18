<!DOCTYPE html>
<html>
  <head>
    <title>AAF Automated Service Provider Installer</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="../css/bootstrap.css" type="text/css" rel="stylesheet" media="screen, projection" />
    <link href="../css/aaf_base_application.css" type="text/css" rel="stylesheet" media="screen, projection"/>

    <script src="../js/jquery-1.7.2.min.js" type="text/javascript" ></script>
    <script src="../js/modernizr-2.6.2.js" type="text/javascript" ></script>
  </head>

  <body>
    
    <header>      
      <div class="container">  
        <div class="row">
          <div class="span12">
            <img src="../logo.jpg" alt="AAF Virtual Home" width="102" height="50" />
            <h1>AAF Automated Service Provider Installer</h1>             
          </div>
        </div>
      </div>
    </header>

    <nav>
      <div class="container">
        <div class="navbar">
          <div class="navbar-inner">
            <ul class="nav">
              <li>
                <a href="#">Dashboard</a>
              </li>
              <li><a href="http://support.aaf.edu.au" target="_blank">Support</a></li>
            </ul>
          </div>
        </div>
      </div>
    </nav>

    <section>
      <div class="container">        
        <div class="row">
          <div class="span12">

            <h1>Congratulations</h1>
            <br>

            <p>You have successfully authenticated to your brand new service provider via the Australian Access Federation.  This page is secure content.</p>

            <p>The environment settings for this service provider are displayed below:</p>

<br>
<br>

<?php 

echo "<table>\n";

foreach ($_SERVER as $key => $value) {
	echo "<tr>\n";
	echo "<td>$key</td><td>$value</td>\n";
	echo "</tr>\n";
} // End foreach

echo "</table>\n";

?>

          </div>
        </div>
      </div>
    </section>
  
    <footer>
      <div class="container"> 
        <div class="row">
          <div class="span12">
            <p>
              AAF Automated Service Provider Installer <strong>version 0.3</strong>
              <br>
              Developed for the <a href="http://www.aaf.edu.au">Australian Access Federation</a> by Paul Stepowski.
            </p>
          </div>
        </div>
      </div>
    </footer>
  </body>

</html>
