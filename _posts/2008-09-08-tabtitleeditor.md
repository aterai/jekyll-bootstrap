---
layout: post
title: JTabbedPaneのタブにJTextFieldを配置してタイトルを編集
category: swing
folder: TabTitleEditor
tags: [JTabbedPane, JTextField, MouseListener, ChangeListener, InputMap, ActionMap]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-09-08

## JTabbedPaneのタブにJTextFieldを配置してタイトルを編集
`JTabbedPane`で選択されたタブに`JTextField`を配置し、そのタイトルを編集します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTU43AZWdI/AAAAAAAAAmw/6klnGPa4D9o/s800/TabTitleEditor.png)

### サンプルコード
<pre class="prettyprint"><code>private Component tabComponent = null;
private int editing_idx = -1;
private int len = -1;
private Dimension dim;
private void startEditing() {
  //System.out.println("start");
  editing_idx  = tabbedPane.getSelectedIndex();
  tabComponent = tabbedPane.getTabComponentAt(editing_idx);
  tabbedPane.setTabComponentAt(editing_idx, editor);
  editor.setVisible(true);
  editor.setText(tabbedPane.getTitleAt(editing_idx));
  editor.selectAll();
  editor.requestFocusInWindow();
  len = editor.getText().length();
  dim = editor.getPreferredSize();
  editor.setMinimumSize(dim);
}
private void cancelEditing() {
  //System.out.println("cancel");
  if(editing_idx&gt;=0) {
    tabbedPane.setTabComponentAt(editing_idx, tabComponent);
    editor.setVisible(false);
    editing_idx = -1;
    len = -1;
    tabComponent = null;
    editor.setPreferredSize(null);
  }
}
private void renameTabTitle() {
  //System.out.println("rename");
  String title = editor.getText().trim();
  if(editing_idx&gt;=0 &amp;&amp; !title.isEmpty()) {
    tabbedPane.setTitleAt(editing_idx, title);
  }
  cancelEditing();
}
</code></pre>

### 解説
`JTabbedPane`のタブタイトルを直接編集します。

`JDK 6`で導入された、`JTabbedPane#setTabComponentAt`メソッドを使用してタブに`JTextField`を追加しています。

操作方法などは、以下のように、`GlassPane`を使用している[JTabbedPaneのタブタイトルを変更](http://terai.xrea.jp/Swing/EditTabTitle.html)と同じですが、こちらは文字が入力されるたびに(`JTabbedPane#revalidate`しているので)タブの幅が広がります。

- 操作方法
    - マウスでタブをダブルクリック、またはタブを選択して<kbd>Enter</kbd>キーで編集開始
    - 編集中に入力欄以外をクリック、または<kbd>Enter</kbd>キーでタイトル文字列が確定
    - 編集中<kbd>Tab</kbd>キーを押しても無視
    - <kbd>Esc</kbd>で編集をキャンセル
    - `0`文字で確定した場合も、キャンセル扱い

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTabbedPaneのタブタイトルを変更](http://terai.xrea.jp/Swing/EditTabTitle.html)
    - こちらは、`JDK 6`以前でも動作するように、`GlassPane`に`JTextField`を配置してタブタイトルの編集を行っています。

<!-- dummy comment line for breaking list -->

### コメント
- `setTabComponentAt(...)`メソッドで閉じるボタンなどと併用していた場合、編集後にそのボタンなどが消える不具合をメールで指摘してもらったので、修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-10 (火) 16:47:33

<!-- dummy comment line for breaking list -->

