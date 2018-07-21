#ifndef MDSMODEL_H
#define MDSMODEL_H

#include <QObject>

class MDSModel : public QObject
{
    Q_OBJECT

public:
    MDSModel(QObject* parent = nullptr);
};

#endif // MDSMODEL_H
