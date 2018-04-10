function segment = cv_updatesegment(data,segment)

segment = cv_updatesegmentarea(data,segment);
segment = cv_updatesegmentcurvature(data,segment);
segment = cv_updatesegmenttorsion(data,segment);
