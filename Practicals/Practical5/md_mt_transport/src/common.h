/* 
 * File:   common.h
 * Author: ewgenij
 *
 * Created on November 13, 2013, 11:38 AM
 */

#ifndef _COMMON_H
#define	_COMMON_H

//#define FERMI_CAPABILITY
#ifdef FERMI_CAPABILITY
#define REAL double
#else
#define REAL float
#endif

typedef struct t_input{
    int M,L;
    REAL vmin, vmax, xmin, xmax;
    REAL tau, tfinish;
}INPUT;

#define NGPUS 2  //затребованы 2 устройства в PBS сценарии
#define pi 3.1415926535897930

#endif	/* _COMMON_H */

