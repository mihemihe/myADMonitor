import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import Alert from 'react-bootstrap/Alert';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Badge from 'react-bootstrap/Badge';


export default function HeaderData({ HeaderDataProp }) {


    return (
        <Container fluid style={{ whiteSpace: "nowrap" }}>
            <Row>
                <Col>
                    <ul style={{ listStyle: "none", fontSize: "0.75rem", textAlign: "left" }}>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Domain: </span> {HeaderDataProp.domainName}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Domain Controller: </span> {HeaderDataProp.domainControllerFQDN}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Custom LDAP: </span> {HeaderDataProp.query}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Changes: </span> {HeaderDataProp.changesDetected}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>USN: </span> {HeaderDataProp.latestUSNDetected}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Total: </span> {HeaderDataProp.objectsInDatabase}
                        </li>

                    </ul>
                </Col>
                <Col>
                    <ul style={{ listStyle: "none", fontSize: "0.75rem", textAlign: "left" }}>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Users: </span> {HeaderDataProp.trackedUsers}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Groups: </span> {HeaderDataProp.trackedGroups}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Computers: </span> {HeaderDataProp.trackedComputers}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Contacts: </span> {HeaderDataProp.trackedContacts}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>OUs: </span> {HeaderDataProp.trackedOUs}
                        </li>
                        <li>
                            <span style={{ fontWeight: "bold" }}>Other: </span> {HeaderDataProp.trackedOther}
                        </li>
                    </ul>
                </Col>
            </Row>

        </Container>
    )
}
