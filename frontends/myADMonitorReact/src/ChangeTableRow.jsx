import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import DeltaValuesFragment from './DeltaValuesFragment';
import React from 'react'


export default function ChangeTableRow({ tableRowProp }) {

    const attributeName = tableRowProp.attributeName;
    const oldvalues = tableRowProp.oldValues;
    const newvalues = tableRowProp.newValues;
    const deltavalues = tableRowProp.deltaValues;
    const issingleormulti = tableRowProp.isSingleOrMulti;
    const whenchangedwhendetected = tableRowProp.whenChangedWhenDetected;

    // { changeCompactAttributes.map(a => (<ChangeTableRow tableRowProp={a} />)) }

    if (issingleormulti == false || attributeName == "useraccountcontrol") {
        return (
            <tr style={{ fontSize: "0.75rem", borderBottom: "solid", "borderWidth": "1px" }}>
                <td style={{ fontWeight: 'bold' }}>{attributeName}</td>
                <td></td>
                {/* <td colspan="2">(+) new user added<br></br>(-) user deleted</td> */}
                {/*                 <td>
                    {deltavalues.map(item => (
                        // Without the `key`, React will fire a key warning
                        <React.Fragment>
                            <div>{item}</div>
                        </React.Fragment>
                    ))}
                </td> */}
                <td style={{ borderLeft: "solid", "borderWidth": "1px" }}>
                    {deltavalues.map(a => (<DeltaValuesFragment deltaValue={a} />))}
                </td>
                <td>{whenchangedwhendetected}</td>
            </tr>


        )
    }
    else {
        return (

            <tr style={{ fontSize: "0.75rem", borderBottom: "solid", "borderWidth": "1px" }}>
                <td style={{ fontWeight: 'bold' }}>{attributeName}</td>
                <td style={{ borderLeft: "solid", "borderWidth": "1px" }}>{oldvalues}</td>
                <td style={{ borderLeft: "solid", "borderWidth": "1px" }} >{newvalues}</td>
                <td>{whenchangedwhendetected}</td>
            </tr>

        )
    }


}