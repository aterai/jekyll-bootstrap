---
layout: post
category: swing
folder: PopupWithoutClickOnMenu
title: JMenuの領域内にマウスカーソルでポップアップメニューを表示する
tags: [JMenu, MouseListener]
author: aterai
pubdate: 2013-02-18T00:29:59+09:00
description: JMenuの領域内にマウスカーソルが入ったときにポップアップメニューが開くように設定します。
image: https://lh3.googleusercontent.com/-shu8CDTfLvg/USCnbrWYstI/AAAAAAAABd0/qODgUmweras/s800/PopupWithoutClickOnMenu.png
comments: true
---
## 概要
`JMenu`の領域内にマウスカーソルが入ったときにポップアップメニューが開くように設定します。

{% download https://lh3.googleusercontent.com/-shu8CDTfLvg/USCnbrWYstI/AAAAAAAABd0/qODgUmweras/s800/PopupWithoutClickOnMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>visitAll(menubar, new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    if (check.isSelected()) {
      ((AbstractButton) e.getComponent()).doClick();
    }
  }
  @Override public void mouseEntered(MouseEvent e) {
    if (check.isSelected()) {
      ((AbstractButton) e.getComponent()).doClick();
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JMenuBar`の子コンポーネントになっている`JMenu`の領域内にマウスカーソルが入った場合に自動的にポップアップメニューが開くように、`JMenu#doClick()`を実行する`MouseListener`を追加しています。

- 注:
    - マウスボタンを押した場合も、入った場合にすでに表示したポップアップメニューが非表示にならないように`JMenu#doClick()`を実行
    - このサンプルのすべての`JMenuItem`は、`beep`音を鳴らすだけのダミー

<!-- dummy comment line for breaking list -->

- - - -
- この`JMenu`の入った、`JPopupMenu`を`JComponent#setComponentPopupMenu(...)`で`JMenuBar`以外のコンポーネントに設定すると無限ループする
    - [Bug ID: JDK-6949414 JMenu.buildMenuElementArray() endless loop](https://bugs.openjdk.java.net/browse/JDK-6949414)
- 回避方法:
    - マウスイベントを作成し、`menu.dispatchEvent(new MouseEvent(menu, MouseEvent.MOUSE_ENTERED, e.getWhen(), 0, 0, 0, 0, false));`を実行する
        - [java - Programmatically expand sub JMenuItems - Stack Overflow](https://stackoverflow.com/questions/25260684/programmatically-expand-sub-jmenuitems)
    - `MenuElement`の配列を作成し、`MenuSelectionManager.defaultManager().setSelectedPath(new MenuElement[]{...});`を実行する
        - ドキュメントには、[「このメソッドは public ですが、Look & Feel エンジンで使用されるため、クライアントアプリケーションからは呼び出さないでください。」](http://docs.oracle.com/javase/jp/7/api/javax/swing/MenuSelectionManager.html#setSelectedPath%28javax.swing.MenuElement%5B%5D%29)と記述されているが、現状では`JMenu`の`buildMenuElementArray(...)`が以下の状態なので仕方ない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>/*
 * Build an array of menu elements - from &lt;code&gt;PopupMenu&lt;/code&gt; to
 * the root &lt;code&gt;JMenuBar&lt;/code&gt;.
 * @param  leaf  the leaf node from which to start building up the array
 * @return the array of menu items
 */
private MenuElement[] buildMenuElementArray(JMenu leaf) {
    Vector&lt;MenuElement&gt; elements = new Vector&lt;MenuElement&gt;();
    Component current = leaf.getPopupMenu();
    JPopupMenu pop;
    JMenu menu;
    JMenuBar bar;

    while (true) {
        if (current instanceof JPopupMenu) {
            pop = (JPopupMenu) current;
            elements.insertElementAt(pop, 0);
            current = pop.getInvoker();
        } else if (current instanceof JMenu) {
            menu = (JMenu) current;
            elements.insertElementAt(menu, 0);
            current = menu.getParent();
        } else if (current instanceof JMenuBar) {
            bar = (JMenuBar) current;
            elements.insertElementAt(bar, 0);
            MenuElement me[] = new MenuElement[elements.size()];
            elements.copyInto(me);
            return me;
        }
    }
}
</code></pre>

## 参考リンク
- [JMenuBarの動作 － Java Solution － ＠IT](http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?topic=9327&forum=12)
- [java - Activate JMenuBar on hover - Stack Overflow](https://stackoverflow.com/questions/12125402/activate-jmenubar-on-hover)

<!-- dummy comment line for breaking list -->

## コメント
