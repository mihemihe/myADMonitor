import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';
import SingleValueRow from './SingleValueRow';
import MultiValueRow from './MultiValueRow';
import React from 'react'

export default function ChangeTableRow({ deltaValue }) {

    let Added = deltaValue.includes("(-)");

    if (Added == false) {
        return (<div style={{ fontSize: "0.75rem", backgroundColor: "#d2fbcb" }}>{deltaValue}</div>)
    }
    else {
        return (<div style={{ fontSize: "0.75rem", backgroundColor: "#fbd0d2" }}>{deltaValue}</div>)

    }
}