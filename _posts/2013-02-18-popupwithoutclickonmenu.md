---
layout: post
title: JMenuの領域内にマウスカーソルでポップアップメニューを表示する
category: swing
folder: PopupWithoutClickOnMenu
tags: [JMenu, MouseListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-02-18

## JMenuの領域内にマウスカーソルでポップアップメニューを表示する
`JMenu`の領域内にマウスカーソルが入ったときにポップアップメニューが開くように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-shu8CDTfLvg/USCnbrWYstI/AAAAAAAABd0/qODgUmweras/s800/PopupWithoutClickOnMenu.png)

### サンプルコード
<pre class="prettyprint"><code>visitAll(menubar, new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    if(check.isSelected()) {
      ((AbstractButton)e.getSource()).doClick();
    }
  }
  @Override public void mouseEntered(MouseEvent e) {
    if(check.isSelected()) {
      ((AbstractButton)e.getSource()).doClick();
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JMenuBar`の子コンポーネントになっている`JMenu`の領域内にマウスカーソルが入った場合に自動的にポップアップメニューが開くように、`JMenu#doClick()`を実行する`MouseListener`を追加しています。

- 注:
    - マウスボタンを押した場合も、入った場合にすでに表示したポップアップメニューが非表示にならないように`JMenu#doClick()`を実行
    - このサンプルのすべての`JMenuItem`は、`beep`音を鳴らすだけのダミー

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JMenuBarの動作 － Java Solution － ＠IT](http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?topic=9327&forum=12)
- [java - Activate JMenuBar on hover - Stack Overflow](http://stackoverflow.com/questions/12125402/activate-jmenubar-on-hover)

<!-- dummy comment line for breaking list -->

### コメント
