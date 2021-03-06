---
layout: post
category: swing
folder: FileViewFullRowSelection
title: JFileChooserのDetails Viewで行全体を選択可能にする
tags: [JFileChooser, JTable, UIManager, LookAndFeel]
author: aterai
pubdate: 2020-05-04T17:55:19+09:00
description: JFileChooserの詳細表示を行うJTableで行全体の選択状態表示とマウスによる行選択を可能に変更します。
image: https://drive.google.com/uc?id=1Kmm_cFFBn4Ox_HtiEZwK3-cmZbWG7BkD
comments: true
---
## 概要
`JFileChooser`の詳細表示を行う`JTable`で行全体の選択状態表示とマウスによる行選択を可能に変更します。

{% download https://drive.google.com/uc?id=1Kmm_cFFBn4Ox_HtiEZwK3-cmZbWG7BkD %}

## サンプルコード
<pre class="prettyprint"><code>String key = "FileView.fullRowSelection";
System.out.println(UIManager.getLookAndFeelDefaults().getBoolean(key));
JCheckBox check = new JCheckBox(key) {
  @Override public void updateUI() {
    super.updateUI();
    setSelected(UIManager.getLookAndFeelDefaults().getBoolean(key));
  }
};
JButton button = new JButton("open");
button.addActionListener(e -&gt; {
  Boolean flg = check.isSelected();
  UIManager.put("FileView.fullRowSelection", flg);
  JFileChooser chooser = new JFileChooser();
  // https://ateraimemo.com/Swing/DetailsViewFileChooser.html
  Optional.ofNullable(chooser.getActionMap().get("viewTypeDetails"))
      .ifPresent(a -&gt; a.actionPerformed(new ActionEvent(
          e.getSource(), e.getID(), "viewTypeDetails")));

  // https://ateraimemo.com/Swing/GetComponentsRecursively.html
  stream(chooser)
      .filter(JTable.class::isInstance).map(JTable.class::cast)
      .findFirst()
      .ifPresent(t -&gt; t.putClientProperty("Table.isFileList", !flg));
  int retValue = chooser.showOpenDialog(getRootPane());
  if (retValue == JFileChooser.APPROVE_OPTION) {
    log.setText(chooser.getSelectedFile().getAbsolutePath());
  }
});
</code></pre>

## 解説
- `FileView.fullRowSelection`: `false`
    - `WindowsLookAndFeel`のデフォルト
    - 詳細表示(`Details View`)用の`JTable`でファイル名を表示する`0`列目のセルの文字列部分のみマウスクリックに反応して選択可能で選択状態表示もファイル名のみ
- `FileView.fullRowSelection`: `true`
    - `NimbusLookAndFeel`のデフォルト
    - 詳細表示(`Details View`)用の`JTable`で行全体に選択状態が表示される
    - デフォルトでは`FileView.fullRowSelection`の設定にかかわらず`JTable#putClientProperty("Table.isFileList", Boolean.TRUE)`が設定されているため、ファイル名を表示する`0`列目のセルの文字列部分のみマウスクリックに反応する
    - 上記のサンプルでは`FileView.fullRowSelection`が`true`の場合は`JTable#putClientProperty("Table.isFileList", Boolean.FALSE)`を設定して行全体でマウスクリックによる選択を可能に変更している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFileChooserのデフォルトをDetails Viewに設定](https://ateraimemo.com/Swing/DetailsViewFileChooser.html)
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- [JTableで文字列をクリックした場合だけセルを選択状態にする](https://ateraimemo.com/Swing/TableFileList.html)

<!-- dummy comment line for breaking list -->

## コメント
