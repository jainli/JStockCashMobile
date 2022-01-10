<?php
  $host ='localhost';
  $database =" gestion_stock_caisse";
  $user ='root';
  $pass ='';
  
  try {
      $db = new PDO("mysql:host".$host." dbname =".$database,$customer_name,$customer_surname,$customer_email,$customer_tel,$customer_city,$customer_status);
  } catch (Exception $e)
  {
echo $e->getMessage();
  }
  $customer_name = $_POST['customer_name'];
  $customer_surname = $_POST['customer_surname'];
  $customer_adresse = $_POST['customer_adresse'];
  $customer_email = $_POST['customer_email'];
  $customer_tel = $_POST['customer_tel'];
  $customer_city = $_POST['customer_city'];
  $customer_status = $_POST['customer_status'];
  // $type= (int)$_POST['type'];


  // $res["msg"]= $user." ".$age."".$customer_surname."".$customer_city."".$customer_tel."".$customer_email."".$customer_adresse."".$customer_name;
  
if($type ==1){
  try{
    $query= $db->prepare("SELECT * FROM customers WHERE customer_name = ? ");
    $query ->execute(array($customer)) ;
    $exist = $query->rowCount();


    if($exist==0){
      $pass=sha1($pass);
      $query = $db->prepare("INSERT INTO customers (customer_name ,customer_surname, customer_adresse,$customer_email,customer_tel,customer_city,customer_status,) VALUES(?,?,?,?,?,?)");
      $query->execute(array($customer_name,$customer_surname,$customer_adresse,$customer_email,$customer_tel,$customer_city,$customer_status));
      $msg["statut"]="Utilisateur Enregistrer avec succes ";
      $msg['val']=1;
    }
    else{
      $msg["statut"]="nom d utilisateur deja attribuer ";
      $msg['val']=1;
    }
    // $msg["nb"]= $exist;

  } catch (Exception $e){

    // $msg["statut"]="erreur d'enregistrement";
  }
}
  else{
    try{
        $pass = sha1($pass);
        $query= $db->prepare("SELECT * FROM customers WHERE customer_name = ? ");
        $query ->execute(array($user,$pass)) ;
        $exist = $query->rowCount();
      if($exist==1){
         $infos= $query->fetch();
          $msg["statut"]="Utilisateur connecter avec succes ";
          $msg['val']=1;
          $msg['Infos']=[
            "nom"=> $info['nom'] 
          ];
        }
      else{
          $msg["statut"]="nom d utilisateur ou mots de passe incorrecte ";
          $msg['val']=0;
      }
      // $msg["nb"]= $exist;
  
    } catch (Exception $e){
  
      // $msg["statut"]="erreur d'enregistrement";
    }
  }

  echo json_encode($res);
  ?>
<!-- if($type==1){
  try{
$query= $db->prepare("SELECT * FROM customer WHERE nom = ? ");
$query ->execute(array($customer)) ;
$exist = $query->rowCount();
if($exist == 0){
  $query = $db->prepare("INSERT INTO customer(customer_name ,customer_surname, customer_adresse,$customer_email,customer_tel,customer_city,customer_status,) VALUES(?,?,?,?,?,?)");
 $query->execute(array($customer_name,$customer_surname,$customer_adresse,$customer_email,$customer_tel,$customer_city,$customer_status));
  $msg['statut']="utilisateur enregistrer avec succès";
  $msg['val']= 1;
}else{  $msg['statut'] = "Nom d'utilisateur deja attribuer";
   $msg['val']= 0;
}
}catch(Exception $e){
}
  echo json_encode($res);
 -->
