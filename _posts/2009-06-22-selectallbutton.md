---
layout: post
category: swing
folder: SelectAllButton
title: JTableを別コンポーネントから操作
tags: [JTable, ActionMap]
author: aterai
pubdate: 2009-06-22T11:18:08+09:00
description: JTableの全選択や選択された行のコピーをJButtonなどの別コンポーネントから行います。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSx9pjE3I/AAAAAAAAAjU/kU0UU-PWKSI/s800/SelectAllButton.png
comments: true
---
## 概要
`JTable`の全選択や選択された行のコピーを`JButton`などの別コンポーネントから行います。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSx9pjE3I/AAAAAAAAAjU/kU0UU-PWKSI/s800/SelectAllButton.png %}

## サンプルコード
<pre class="prettyprint"><code>private final JTable table = new JTable(model);
private final Action copyAction = new AbstractAction("copy") {
  @Override public void actionPerformed(ActionEvent e) {
    e.setSource(table);
    table.getActionMap().get("copy").actionPerformed(e);
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JButton`や`JMenuItem`がクリックされたときに以下のようにしてフォーカスのない`JTable`の全選択とコピーを行っています。

- `AWTEvent#setSource(Object)`メソッドでイベントを`JTable`に再転送
    - `Exception in thread "AWT-EventQueue-0" java.lang.ClassCastException: javax.swing.JMenuItem cannot be cast to javax.swing.JTable`などの例外が発生しないようにするために再転送が必要
- `JTable`から`ActionMap`を取得
- `ActionMap`から`Action`を取得
    - これらの`Action`は`JTable`でコピー(<kbd>Ctrl+C</kbd>)するのと同様
- `ActionListener#actionPerformed(ActionEvent)`メソッドで`Action`を実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ActionMap (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ActionMap.html)

<!-- dummy comment line for breaking list -->

## コメント
- タイトルの`typo`を修正 -- *aterai* 2009-06-23 (火) 18:34:44
- `Java Web Start`で起動した場合は、 ~~コピーできない？~~ このサンプル内でコピーした文字列などを外部のアプリケーションにペーストすることはできない(逆も不可)？ -- *aterai* 2009-10-02 (金) 19:05:43

<!-- dummy comment line for breaking list -->
