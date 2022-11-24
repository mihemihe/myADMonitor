import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
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