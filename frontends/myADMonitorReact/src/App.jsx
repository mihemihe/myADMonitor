import { useState } from 'react'
import Change from './Change.jsx';
import ChangeCompact from './ChangeCompact.jsx';
import ChangeTable from './ChangeTable.jsx';
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import { useEffect } from 'react';


import './App.css'
import NavbarClassic from './Navbar.jsx';
import HeaderData from './HeaderData.jsx';

const API_URL = 'http://localhost:5000/api/CacheInfo/recentchanges3';
const API_URL_HEADER = 'http://localhost:5000/api/CacheInfo/headerdata';




function App() {
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
