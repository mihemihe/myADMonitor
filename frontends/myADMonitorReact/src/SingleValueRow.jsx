import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';


export default function SingleValueRow({ attChangeProp }) {

    const attributeName = attChangeProp.attributeName;
    const oldvalues = attChangeProp.oldValues;
    const newvalues = attChangeProp.newValues;
    const deltavalues = attChangeProp.deltaValues;
    const issingleormulti = attChangeProp.isSingleOrMulti;
    const whenchangedwhendetected = attChangeProp.whenChangedWhenDetected;


    return (

        <tr>
            <td>name</td>
            <td>name01</td>
            <td>name02</td>
            <td>18:00:00</td>
        </tr>
    )

}