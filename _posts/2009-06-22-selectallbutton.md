---
layout: post
title: JTableを別コンポーネントから操作
category: swing
folder: SelectAllButton
tags: [JTable, ActionMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-06-22

## JTableを別コンポーネントから操作
`JTable`の全選択や選択された行のコピーを`JButton`などの別コンポーネントから行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTSx9pjE3I/AAAAAAAAAjU/kU0UU-PWKSI/s800/SelectAllButton.png)

### サンプルコード
<pre class="prettyprint"><code>private final JTable table = new JTable(model);
private final Action copyAction = new AbstractAction("copy") {
  public void actionPerformed(ActionEvent e) {
    e.setSource(table);
    table.getActionMap().get("copy").actionPerformed(e);
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JButton`や`JMenuItem`がクリックされたときに、以下のようにしてフォーカスのない`JTable`の全選択やコピーを行っています。

- `AWTEvent#setSource(Object)`メソッドでイベントを`JTable`に再転送
    - `Exception in thread "AWT-EventQueue-0" java.lang.ClassCastException: javax.swing.JMenuItem cannot be cast to javax.swing.JTabl`などの例外が発生しないように
- `JTable`から`ActionMap`を取得
- `ActionMap`から`Action`を取得
    - これらの`Action`は`JTable`でコピー(<kbd>Ctrl</kbd>+<kbd>C</kbd>)するのと同様
- `ActionListener#actionPerformed(ActionEvent)`メソッドで`Action`を実行

<!-- dummy comment line for breaking list -->

### コメント
- タイトルの`typo`を修正 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-06-23 (火) 18:34:44
- `Java Web Start`で起動した場合は、 ~~コピーできない？~~ このサンプル内でコピーした文字列などを外部のアプリケーションにペーストすることはできない(逆も不可)？ -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-02 (金) 19:05:43

<!-- dummy comment line for breaking list -->

