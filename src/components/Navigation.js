import  Navbar  from 'react-bootstrap/Navbar';
import logo from '../logo.svg';

const Navigation = () => {
  return (
    <Navbar>
        <img 
            src={logo} 
            width="40" 
            height="40" 
            className="d-inline-block align-top mx-3" 
            alt="DApp ICO Crowdsale logo" 
        />
        <Navbar.Brand href="#">
            DApp ICO Crowdsale
        </Navbar.Brand>
    </Navbar>
  );
}

export default Navigation;
