import { useState } from 'react'
import ChangeTable from './ChangeTable.jsx';
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Container from 'react-bootstrap/Container';
import { useEffect } from 'react';


import './App.css'
import NavbarClassic from './Navbar.jsx';
import HeaderData from './HeaderData.jsx';










function App() {

  var hardCodedURLForDev = true
  var API_URL = ""
  var API_URL_HEADER = ""
  if (hardCodedURLForDev) {
    API_URL = 'http://localhost:5000/api/CacheInfo/recentchanges3';
    API_URL_HEADER = 'http://localhost:5000/api/CacheInfo/headerdata';
    console.log(API_URL)
    console.log(API_URL_HEADER)
    console.log("URL hardcoded - Development")

  }
  else {
    API_URL = window.location.protocol + "//" + window.location.host + "/api/CacheInfo/recentchanges3"
    API_URL_HEADER = window.location.protocol + "//" + window.location.host + "/api/CacheInfo/headerdata"
    console.log(API_URL)
    console.log(API_URL_HEADER)
    console.log("URL no hardcoded - Production")
  }
  const [changes, setChanges] = useState([]);
  const [stats, setStats] = useState([]);

  const [time, setTime] = useState(Date.now());
  const seconds = 2000;

  const getChanges = async () => {
    const response = await fetch(API_URL);
    const data = await response.json();
    data.reverse();
    console.log(data);
    setChanges(data);
  }

  const getHeaderData = async () => {
    const response = await fetch(API_URL_HEADER);
    const data = await response.json();
    console.log(data);
    setStats(data);
  }

  // update component ever n seconds


  useEffect(() => {
    // getChanges();


    const interval = setInterval(() => { getChanges() }, seconds)
    const interval2 = setInterval(() => { getHeaderData() }, seconds * 2)

    return () => clearInterval(interval, interval2)




  }, []);



  return (

    <Container fluid>
      <NavbarClassic></NavbarClassic>
      <HeaderData HeaderDataProp={stats} ></HeaderData>
      <h3>Pulling latest changes every {seconds / 1000} seconds...</h3>
      {changes.map(c => (<ChangeTable recentEvent={c} />))}
    </Container>
  )
}

export default App
