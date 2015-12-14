#!/bin/sh
BASEDIR=/opt/hercules/guests/110S/DASD
OUTPUTDIR=/opt/hercules/dump/110S

for TOPDIR in `ls $TOPDIR $BASEDIR`
do
        echo -e \(-\) Working on directory: $BASEDIR/$TOPDIR
        # Entered toplevel directory to look for CCKDs

        for CCKD in `ls $BASEDIR/$TOPDIR/*.CCKD`
        do
                echo -e \ \|\ \(+\) Found Device: `basename $CCKD`
                # Working on individual CCKD
                for DATASET in `dasdls $CCKD 2> /dev/null | sed '1,/VOLSER/d'`
                do
                        echo -e \ \|\ \ \|\ \ Found Dataset: $DATASET
                        mkdir -p $OUTPUTDIR/`basename $CCKD`
                        cd $OUTPUTDIR/`basename $CCKD`
                        echo -e \ \|\ \ \|\ \ \ \ Extracting...
                        echo -e \ \|\ \ \|\ \ \ \ Attempting DS...

                        dasdseq -ascii $CCKD $DATASET > /dev/null 2>&1

                        if [ ! -f $OUTPUTDIR/`basename $CCKD`/$DATASET ]; then
                                # Dataset file wasn't created, assuming dataset is PDS.
                                echo -e \ \|\ \ \|\ \ \ \ Attempting PDS since no DS was created...
                                mkdir -p $OUTPUTDIR/`basename $CCKD`/$DATASET
                                cd $OUTPUTDIR/`basename $CCKD`/$DATASET
                                dasdpdsu $CCKD $DATASET ascii > /dev/null 2>&1
                        fi
                done
        done

done

