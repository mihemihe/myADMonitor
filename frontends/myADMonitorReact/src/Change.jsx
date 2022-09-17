import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';


export default function Change({ recentEvent }) {

    const guid = recentEvent.guid;
    const attributeName = recentEvent.attributeName;
    const fromNewOrChange = recentEvent.fromNewOrChange;
    console.log(typeof fromNewOrChange);
    const isSingleOrMulti = recentEvent.isSingleOrMulti.toString();
    console.log(typeof isSingleOrMulti);
    const usn = recentEvent.usn;
    const whenChangedWhenDetected = recentEvent.whenChangedWhenDetected;
    const whenDetected = recentEvent.whenDetected;
    const oldValues = recentEvent.oldValues;
    const newValues = recentEvent.newValues;
    const friendlyName = recentEvent.friendlyName;
    const objectClass = recentEvent.objectClass;

    return (
        <Container fluid style={{ whiteSpace: "nowrap"}}>
            <Alert variant='success'>

                <Row>
                    <Col sm={8}><Badge bg="dark">{friendlyName}</Badge></Col>
                    <Col sm={4}><Badge bg="danger">{attributeName}</Badge></Col>
                </Row>
                <Row style={{ marginTop: "2px", marginBottom: "2px" }}><hr></hr></Row>
                <Row>
                    <Col>
                        <ul style={{ listStyle: "none", fontSize: "0.75rem", textAlign: "left" }}>
                            <li>
                                <span style={{ fontWeight: "bold" }}>Class: </span>
                                <span style={{ color: "gray" }}>{objectClass}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>Guid: </span>
                                <span style={{ color: "gray" }}>{guid}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>Attribute: </span>
                                <span style={{ color: "gray" }}>{attributeName}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>New object: </span>
                                <span style={{ color: "gray" }}>{fromNewOrChange}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>Single value: </span>
                                <span style={{ color: "gray" }}>{isSingleOrMulti}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>USN: </span>
                                <span style={{ color: "gray" }}>{usn}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>When Changed: </span>
                                <span style={{ color: "gray" }}>{whenChangedWhenDetected}</span>
                            </li>
                            <li>
                                <span style={{ fontWeight: "bold" }}>When Detected: </span>
                                <span style={{ color: "gray" }}>{whenDetected}</span>
                            </li>
                        </ul>
                    </Col>
                    <Col>
                        <ul style={{ listStyle: "none", fontSize: "0.75rem", textAlign: "left", padding: "0" }}>
                            <li>
                                <Badge bg="success" >OLD VALUES:</Badge>
                                <ul style={{ listStyle: "none", padding: "0" }}>
                                    {oldValues.map(oldValue => (<li style={{ color: "gray" }}>{oldValue}</li>))}
                                </ul>


                            </li>
                        </ul>
                    </Col>
                    <Col>
                        <ul style={{ listStyle: "none", fontSize: "0.75rem", textAlign: "left", padding: "0" }}>
                            <li>
                                <Badge bg="success" >NEW VALUES:</Badge>
                                <ul style={{ listStyle: "none", padding: "0" }}>
                                    {newValues.map(newValue => (<li style={{ color: "gray" }}>{newValue}</li>))}
                                </ul>


                            </li>
                        </ul>
                    </Col>
                </Row>
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