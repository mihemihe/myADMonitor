import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';
import ChangeCompactSub from './ChangeCompactSub.jsx';


export default function ChangeCompact({ recentEvent }) {

    const guid = recentEvent.guid;
    const friendlyName = recentEvent.friendlyName;
    const changeCompactAttributes = recentEvent.changeCompactAttributes;
    const objectClass = recentEvent.objectClass;


    
    

    return (
        <Container fluid style={{ whiteSpace: "nowrap"}}>
            <Alert variant='success'>
                <Row>{friendlyName} {objectClass}</Row>
                <Row style={{ marginTop: "2px", marginBottom: "2px" }}>
                    <Col sm={2}>Attribute Name</Col>
                    <Col sm={3}>Old Values</Col>
                    <Col sm={3}>New Values</Col>
                    <Col sm={3}>Delta Values</Col>
                    <Col sm={1}>whenChanged</Col>
                </Row>
                    {/* <ChangeCompactSub></ChangeCompactSub> */}
                    {changeCompactAttributes.map(attchange => (<ChangeCompactSub attChangeProp={attchange} />))}


                
            </Alert>

            {/*             <Alert variant='success'>
                <ul style={{ listStyle: "none" }}>
                    <li>
                        <span style={{ fontWeight: "bold" }}>Name:</span>
                        <span style={{ color: "gray" }}>{friendlyName}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>Class:</span>
                        <span style={{ color: "gray" }}>{objectClass}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>GUID:</span>
                        <span style={{ color: "gray" }}>{guid}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>Attribute:</span>
                        <span style={{ color: "gray" }}>{attributeName}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>from new?:</span>
                        <span style={{ color: "gray" }}>{fromNewOrChange}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>Single or multi:</span>
                        <span style={{ color: "gray" }}>{isSingleOrMulti}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>USN:</span>
                        <span style={{ color: "gray" }}>{usn}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>whenChanged:</span>
                        <span style={{ color: "gray" }}>{whenChangedWhenDetected}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>whenDetected:</span>
                        <span style={{ color: "gray" }}>{whenDetected}</span>
                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>old values:</span>
                        <span>
                            <ul style={{ listStyle: "none" }}>
                                {oldValues.map(oldValue => (<li style={{ color: "gray" }}>{oldValue}</li>))}
                            </ul>
                        </span>

                    </li>
                    <li>
                        <span style={{ fontWeight: "bold" }}>new values:</span>
                        <span>
                            <ul style={{ listStyle: "none" }}>
                                {newValues.map(newValue => (<li style={{ color: "gray" }}>{newValue}</li>))}
                            </ul>
                        </span>

                    </li>
                </ul>
            </Alert> */}


        </Container>
    )
}