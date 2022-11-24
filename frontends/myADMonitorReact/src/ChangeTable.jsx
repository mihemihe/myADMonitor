import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Badge from 'react-bootstrap/Badge';

import ChangeTableRow from './ChangeTableRow.jsx';


export default function ChangeTable({ recentEvent }) {

    const guid = recentEvent.guid;
    const friendlyName = recentEvent.friendlyName;
    const changeCompactAttributes = recentEvent.changeCompactAttributes;
    const objectClass = recentEvent.objectClass;


    {/* {changeCompactAttributes.map(attchange => (<ChangeCompactSub attChangeProp={attchange} />))} */ }


    return (
        <table style={{ "width": "100%", "borderWidth": "1px", 'borderColor': "#aaaaaa", 'borderStyle': 'solid', textAlign: "left", marginBottom: "8px" }} >
            <tbody>
                <tr style={{ "borderWidth": "1px", 'borderColor': "#aaaaaa", 'borderStyle': 'solid' }}>
                    <td><Badge bg="primary">{friendlyName}</Badge> <Badge bg="primary">{objectClass}</Badge></td>
                    <td colSpan="3"></td>
                </tr>
                <tr style={{ "borderWidth": "1px", 'borderColor': "#aaaaaa", 'borderStyle': 'solid', fontWeight: "bold" }}>
                    <td>Attribute</td>
                    <td>Before</td>
                    <td>After</td>
                    <td>When</td>
                </tr>
                {changeCompactAttributes.map(a => (<ChangeTableRow tableRowProp={a} />))}
            </tbody>
        </ table >





    )
}