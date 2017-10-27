---
layout: post
category: swing
folder: PersistenceDelegate
title: JTableのモデルをXMLファイルで保存、復元する
tags: [JTable, DefaultTableModel, XMLEncoder, XMLDecoder]
author: aterai
pubdate: 2014-10-13T03:04:26+09:00
description: JTableのモデルをXMLEncoderとXMLDecoderを使って、XMLファイルで保存、復元します。
image: https://lh4.googleusercontent.com/-QHfYzslScHI/VDq8gaSQpBI/AAAAAAAACO4/AI-q_jZ-qpA/s800/PersistenceDelegate.png
comments: true
---
## 概要
`JTable`のモデルを`XMLEncoder`と`XMLDecoder`を使って、`XML`ファイルで保存、復元します。

{% download https://lh4.googleusercontent.com/-QHfYzslScHI/VDq8gaSQpBI/AAAAAAAACO4/AI-q_jZ-qpA/s800/PersistenceDelegate.png %}

## サンプルコード
<pre class="prettyprint"><code>class DefaultTableModelPersistenceDelegate extends DefaultPersistenceDelegate {
  @Override protected void initialize(
        Class&lt;?&gt; type, Object oldInstance, Object newInstance, Encoder encoder) {
    super.initialize(type, oldInstance,  newInstance, encoder);
    DefaultTableModel m = (DefaultTableModel) oldInstance;
    for (int row = 0; row &lt; m.getRowCount(); row++) {
      for (int col = 0; col &lt; m.getColumnCount(); col++) {
        Object[] o = new Object[] {m.getValueAt(row, col), row, col};
        encoder.writeStatement(new Statement(oldInstance, "setValueAt", o));
      }
    }
  }
}
</code></pre>

## 解説
- `XMLEncoder`ボタンをクリック
    - `XMLEncoder#setPersistenceDelegate(...)`で、`DefaultTableModel`の書き出しを自作の`DefaultTableModelPersistenceDelegate`に設定
    - テンポラリディレクトリに`XML`ファイルの書き出しと、`JTextArea`にその`XML`ファイルの読み込み

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>try {
  File file = File.createTempFile("output", ".xml");
  try (XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(file)))) {
    xe.setPersistenceDelegate(DefaultTableModel.class, new DefaultTableModelPersistenceDelegate());
    xe.writeObject(model);
    //xe.flush();
    //xe.close();
  }
  try (Reader r = new BufferedReader(new InputStreamReader(
                  new FileInputStream(file), StandardCharsets.UTF_8))) {
    textArea.read(r, "temp");
  }
} catch (IOException ex) {
  ex.printStackTrace();
}
</code></pre>

- `XMLDecoder`ボタンをクリック
    - `JTextArea`に読み込まれている`XML`ファイルを`XMLDecoder`で`DefaultTableModel`に復元、`JTable#setModel(...)`で設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>try (XMLDecoder xd = new XMLDecoder(new BufferedInputStream(
        new ByteArrayInputStream(textArea.getText().getBytes("UTF-8"))))) {
  model = (DefaultTableModel) xd.readObject();
  table.setModel(model);
} catch (IOException ex) {
  ex.printStackTrace();
}
</code></pre>

- `clear`ボタンをクリック
    - 初期状態の`DefaultTableModel`を`JTable`に設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Using XMLEncoder (web.archive.org)](http://web.archive.org/web/20090806075316/http://java.sun.com/products/jfc/tsc/articles/persistence4/)
    - [Using XMLEncoder](http://www.oracle.com/technetwork/java/persistence4-140124.html)
- [JTable Inhalte speichern – Byte-Welt Wiki](https://ateraimemo.com/http://wiki.byte-welt.net/wiki/JTable_speichern.html)
- [PersistenceServiceを使ってJFrameの位置・サイズを記憶](https://ateraimemo.com/Swing/PersistenceService.html)
- [JTableのSortKeyを永続化し、ソート状態の保存と復元を行う](https://ateraimemo.com/Swing/SortKeyPersistence.html)
- [TableColumnModelをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/ColumnModelPersistence.html)

<!-- dummy comment line for breaking list -->

## コメント
