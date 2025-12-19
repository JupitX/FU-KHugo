import Metadata from "../../components/common/Metadata";
import AuthenticationLayout from "../../layout/AuthenticationLayout";
import SignInForm from "../../components/authentication/SignInForm";

export default function SignIn() {
    return (
        <>
            <Metadata title="FuckHugo C2C - Sign In" description="This is the sign in page to use FuckHugo C2C dashboard"/>
            <AuthenticationLayout>
                <SignInForm/>
            </AuthenticationLayout>
        </>
    )
}