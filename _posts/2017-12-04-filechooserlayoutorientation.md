---
layout: post
category: swing
folder: FileChooserLayoutOrientation
title: JFileChooserのリスト表示を垂直1列に変更する
tags: [JFileChooser, JList, HierarchyListener]
author: aterai
pubdate: 2017-12-04T15:25:19+09:00
description: JFileChooserのリスト表示をデフォルトの垂直優先ニュースペーパースタイルから、JListのデフォルトである垂直1列スタイルに変更します。
image: https://drive.google.com/uc?id=1h6JaUr4zBG52EWKWwBHP2unFTL_rm_r9HA
comments: true
---
## 概要
`JFileChooser`のリスト表示をデフォルトの垂直優先ニュースペーパースタイルから、`JList`のデフォルトである垂直`1`列スタイルに変更します。

{% download https://drive.google.com/uc?id=1h6JaUr4zBG52EWKWwBHP2unFTL_rm_r9HA %}

## サンプルコード
<pre class="prettyprint"><code>JButton button2 = new JButton("LayoutOrientation: VERTICAL");
button2.addActionListener(e -&gt; {
  JFileChooser chooser = new JFileChooser();
  stream(chooser)
    .filter(JList.class::isInstance)
    .map(JList.class::cast)
    .findFirst()
    .ifPresent(list -&gt; {
      list.addHierarchyListener(new HierarchyListener() {
        @Override public void hierarchyChanged(HierarchyEvent e) {
          if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0
              &amp;&amp; e.getComponent().isShowing()) {
            list.putClientProperty("List.isFileList", Boolean.FALSE);
            list.setLayoutOrientation(JList.VERTICAL);
          }
        }
      });
    });
  int retvalue = chooser.showOpenDialog(log.getRootPane());
  if (retvalue == JFileChooser.APPROVE_OPTION) {
    log.setText(chooser.getSelectedFile().getAbsolutePath());
  }
});
</code></pre>

## 解説
- `Default`
    - `JFileChooser`の`JList`を使用するリスト表示のデフォルトは、ファイルが垂直方向の次に水平方向の順に並ぶ「ニュースペーパー・スタイル」
    - 名前が長いファイルが存在すると、リストが見づらくなる
- `LayoutOrientation: VERTICAL`
    - `JFileChooser`の子要素を検索して`JList`を取得し、`JList#setLayoutOrientation(JList.VERTICAL)`でファイルが垂直方向`1`列に配置されるよう設定
    - `sun.swing.FilePane#setViewType(...)`が実行されて表示形式が`JTable`を使用する`viewTypeDetails`から`JList`を使用する`viewTypeList`に切り替わる度に`JList#setLayoutOrientation(JList.VERTICAL_WRAP)`が実行されるため、`JList`が`JFileChooser`に設定されて表示されると`JList#setLayoutOrientation(JList.VERTICAL)`を実行する`HierarchyListener`を追加
    - 注: コメントで指摘されているように、`sun.swing.FilePane`を使用しない`LookAndFeel`ではこのサンプルは無意味
        - 例えば`GTKLookAndFeel`ではディレクトリ用とファイル用に`JList`が使用されているが、どちらも垂直方向`1`列がデフォルト

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JList#setLayoutOrientation(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#setLayoutOrientation-int-)
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- [java - Vertical scrolling with a single column in JFileChooser - Stack Overflow](https://stackoverflow.com/questions/47569152/vertical-scrolling-with-a-single-column-in-jfilechooser)

<!-- dummy comment line for breaking list -->

## コメント
