#pragma once

#include <qt/QtCore/QEvent>
#include <qt/QtCore/QObject>

namespace statusbar {

template<typename A>
struct EventFilter : QObject {
    A a;

    EventFilter(A const&);

    auto eventFilter(
        QObject *,
        QEvent *
    ) -> bool;
};

template<typename A>
EventFilter<A>::EventFilter(A const& a) : a {a} {
}

template<typename A>
auto EventFilter<A>::eventFilter(
    QObject * o,
    QEvent * e
) -> bool {
    if (a(o, e))
        return true;
    else
        return QObject::eventFilter(o, e);
}

}
