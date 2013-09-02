---
layout: post
title: JFileChooserで読み取り専用ファイルのリネームを禁止
category: swing
folder: RenameIfCanWriteFileChooser
tags: [JFileChooser, File, BasicDirectoryModel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-10-17

## JFileChooserで読み取り専用ファイルのリネームを禁止
`JFileChooser`で読み取り専用属性ファイルのリネームを禁止します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-7ODSj6DaIig/TpsQEay0NqI/AAAAAAAABDs/8fz14wjADj0/s800/RenameIfCanWriteFileChooser.png)

### サンプルコード
<pre class="prettyprint"><code>class CanWriteFileChooserUI extends MetalFileChooserUI{
  protected CanWriteFileChooserUI(JFileChooser chooser) {
    super(chooser);
  }
  public static ComponentUI createUI(JComponent c) {
    return new CanWriteFileChooserUI((JFileChooser)c);
  }
  private BasicDirectoryModel model2 = null;
  @Override public void createModel() {
    if(model2!=null) {
      model2.invalidateFileCache();
    }
    model2 = new BasicDirectoryModel(getFileChooser()) {
      @Override public boolean renameFile(File oldFile, File newFile) {
        return oldFile.canWrite()?super.renameFile(oldFile, newFile):false;
      }
    };
  }
  @Override public BasicDirectoryModel getModel() {
    return model2;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`BasicDirectoryModel#renameFile(...)`をオーバーライドして取り専用属性ファイルのリネームを確定しようとすると警告ダイアログが表示されるようになっています。

- - - -
`sun.swing.FilePane#canWrite(File)`をオーバーライドすれば、編集開始自体を禁止にすることもできそうですが、`MetalFileChooserUI`などの`UI`で`FilePane`が`private`になっているためかなり面倒です。

### 参考リンク
- [OTN Discussion Forums : How does the JFileChooser "readOnly" ...](https://forums.oracle.com/forums/thread.jspa?threadID=2298004)
- [JFileChooserを編集不可にする](http://terai.xrea.jp/Swing/ROFileChooser.html)

<!-- dummy comment line for breaking list -->

### コメント
