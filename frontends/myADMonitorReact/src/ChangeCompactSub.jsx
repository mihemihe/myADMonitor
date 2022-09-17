import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';


export default function ChangeCompactSub({ attChangeProp }) {

    const attributeName = attChangeProp.attributeName;
    const oldvalues = attChangeProp.oldValues;
    const newvalues = attChangeProp.newValues;
    const deltavalues = attChangeProp.deltaValues;
    const issingleormulti = attChangeProp.isSingleOrMulti;
    const whenchangedwhendetected = attChangeProp.whenChangedWhenDetected;

    if (issingleormulti)
    {
        return ( //Single Value
            <Container fluid style={{ fontSize: "0.75rem", textAlign: "left"}}>

                <Row style={{ marginTop: "2px", marginBottom: "2px" }}>
                    <Col>IF{attributeName}</Col>
                    <Col>{oldvalues}</Col>
                    <Col>{newvalues}</Col>
                    <Col style={{ wordWrap: "break-word", }}>{deltavalues}</Col>
                    <Col>{whenchangedwhendetected}</Col>
                </Row>
            </Container>)
    } else {
        return ( // Multi Value
            <Container fluid style={{ fontSize: "0.75rem", textAlign: "left"}}>

                <Row style={{ marginTop: "2px", marginBottom: "2px" }}>
                    <Col sm={2}>ELSE{attributeName}</Col>
                    <Col sm={3}>aaaaa</Col>
                    <Col sm={3}>bbbbb</Col>
                    <Col sm={3} style={{ wordWrap: "break-word", }}>{deltavalues}</Col>
                    <Col sm={1}>{whenchangedwhendetected}</Col>
                </Row>
            </Container>)

    }    
}