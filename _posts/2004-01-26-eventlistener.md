---
layout: post
category: swing
folder: EventListener
title: EventListenerを実装して独自イベント作成
tags: [EventListener, EventListenerList]
author: aterai
pubdate: 2004-01-26
description: イベント(イベントオブジェクト、イベントリスナー、イベントソース)を新たに作成し、これを使用します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMNwgwo5I/AAAAAAAAAY0/lpZGrcgRE8g/s800/EventListener.png
comments: true
---
## 概要
イベント(イベントオブジェクト、イベントリスナー、イベントソース)を新たに作成し、これを使用します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMNwgwo5I/AAAAAAAAAY0/lpZGrcgRE8g/s800/EventListener.png %}

## サンプルコード
<pre class="prettyprint"><code>interface FontChangeListener extends EventListener {
  public void fontStateChanged(FontChangeEvent e);
}
class FontChangeEvent extends EventObject {
  private final String command;
  private final Font font;
  public String getCommand() {
    return command;
  }
  public Font getFont() {
    return font;
  }
  public FontChangeEvent(Object source, String cmd, Font font) {
    super(source);
    this.command = cmd;
    this.font = font;
  }
}
</code></pre>
<pre class="prettyprint"><code>private final Vector listenerList = new Vector();
public void addFontChangeListener(FontChangeListener l) {
  if (!listenerList.contains(l)) {
    listenerList.add(l);
  }
}
public void removeFontChangeListener(FontChangeListener l) {
  listenerList.remove(l);
}
public void fireFontChangeEvent(String cmd, Font font) {
  Vector list = (Vector) listenerList.clone();
  Enumeration e = list.elements();
  FontChangeEvent evt = new FontChangeEvent(this, cmd, font);
  while (e.hasMoreElements()) {
    FontChangeListener listener = (FontChangeListener) e.nextElement();
    listener.fontStateChanged(evt);
  }
  revalidate();
}
</code></pre>

## 解説
上記のサンプルでは`JMenuItem`に設定したイベントでコンポーネントのフォントを変更できます。ラベルとボタンをその独自イベントのリスナーとして追加しているので、`fireFontChangeEvent(...)`メソッド内でそれらのフォントサイズが変更可能です。

`Java`のイベントモデルは、`delegation event model`(委譲型のイベントモデル)です。
- - - -
リスナーの保存に`Vector`ではなく、`EventListenerList`を使用する場合は[EventListenerList](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/EventListenerList.html)ドキュメントのサンプルが参考になります。

<pre class="prettyprint"><code>// https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/EventListenerList.html
EventListenerList listenerList = new EventListenerList();
//FontChangeEvent fontChangeEvent = null;
public void addFontChangeListener(FontChangeListener l) {
  listenerList.add(FontChangeListener.class, l);
}
public void removeFontChangeListener(FontChangeListener l) {
  listenerList.remove(FontChangeListener.class, l);
}
// Notify all listeners that have registered interest for
// notification on this event type.The event instance
// is lazily created using the parameters passed into
// the fire method.
protected void fireFontChangeEvent(String cmd, Font font) {
  // Guaranteed to return a non-null array
  Object[] listeners = listenerList.getListenerList();
  FontChangeEvent evt = new FontChangeEvent(this, cmd, font);
  // Process the listeners last to first, notifying
  // those that are interested in this event
  for (int i = listeners.length - 2; i &gt;= 0; i -= 2) {
    if (listeners[i] == FontChangeListener.class) {
      // Lazily create the event:
      // if (fontChangeEvent == null)
      //   fontChangeEvent = new FontChangeEvent(this);
      ((FontChangeListener) listeners[i + 1]).fontStateChanged(evt);
    }
  }
}
</code></pre>

## 参考リンク
- ~~[イベント](http://www.asahi-net.or.jp/~dp8t-asm/java/tips/Event.html)~~
- [EventListenerList (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/EventListenerList.html)
- [習慣の生き物 - Kazzzの日記](http://d.hatena.ne.jp/Kazzz/20080618/p1)

<!-- dummy comment line for breaking list -->

## コメント
- `EventListenerList`を使用する方法を追加、リンクを追加、整理。 -- *aterai* 2008-06-18 (水) 12:57:22

<!-- dummy comment line for breaking list -->
