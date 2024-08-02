// XSPEC model subroutine for redshifted "partial covering
// absorption". Assumes that part of the emitter is covered by
// the given absorption and the rest of the emitter is unobscured.
//---
// number of model parameters: 7
//      0      NH       Hydrogen column density (in units of 10**22
//                      atoms per square centimeter
//      1      log_xi   Logarithmic ionization parameter
//      2      PhoIndex Photon index of ionization spectrum
//      3      vturb    Turbulent velocity
//      4      CvrFract Covering fraction (0 implies no absorption,
//                      1 implies the emitter is all absorbed with
//                      the indicated column NH
//      5      vout     Radial velosity
//      6      Redshift

#include <xsTypes.h>
#include <functionMap.h>
#include <XSUtil/Numerics/Numerics.h>
#include <XSFunctions/Utilities/FunctionUtility.h>
extern "C" {
void Uzxipcf(const RealArray& energyArray, const RealArray& params,
    int spectrumNumber, RealArray& trans, RealArray& transErr,
    const string& initString)
{
    using namespace Numerics;

    RealArray eparams(5);
    eparams[0] = params[0];//*1.e22;   //  Hydrogen column density nh in units of 1e22 for param(0)
    eparams[1] = params[1];         //  Logarithmic ionization parameter logxi
    eparams[2] = params[2];         //  Photon Index
    eparams[3] = params[3];         //  Turbulent velocity

    double vout = params[5];        //  vout
    double z = params[6];           //  redshift of target
    double z0 = sqrt(1 - vout*vout/(LIGHTSPEED*LIGHTSPEED)) / (1 - vout/LIGHTSPEED) - 1; // redshift of vout

    eparams[4] = z + z0;            //  z

    // find the path to the mtable file required

    string pname = "UZXIPCF_DIR";
    string DirName(FunctionUtility::getModelString(pname));
    if ( DirName.length() == 0 || DirName == FunctionUtility::NOT_A_KEY() ) {
        DirName = FunctionUtility::modelDataPath();
        const char* env_p = getenv("UZXIPCF_DATA_PATH");
        if (env_p==nullptr) {
          cout<< "The environment variable UZXIPCF_DATA_PATH was not found" <<endl;
          cout<< "Please set the directory, which has uzxipcf_mtable.fits" <<endl;
          string DirName = "./";
        } else {
          string DirName = string(env_p);
        }
    }

    string fileName = DirName + "uzxipcf_mtable.fits";

    // interpolate on the mtable

    FunctionUtility::tableInterpolate(energyArray, eparams, fileName,
        trans, transErr, initString, "mul", true);
    if ( trans.size() == 0 ) {
        FunctionUtility::xsWrite("Failed to read "+fileName+" use xset UZXIPCF_DIR to set directory containing file", 5);
        return;
      }

      // now modify for the partial covering

    trans = (1.0-params[4]) + params[4]*trans;
    if (transErr.size() > 0 ) transErr = (1.0-params[4]) + params[4]*transErr;

    return;
}
}
