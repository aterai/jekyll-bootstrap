---
layout: post
title: Resourceファイルからメニューバーを生成
category: swing
folder: ResourceMenuBar
tags: [JMenuBar, JMenu, JMenuItem, Properties, ResourceBundle]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-10-06

## Resourceファイルからメニューバーを生成
リソースファイルを使ってメニューバーやツールバーを生成します。詳しくは`%JAVA_HOME%/demo/jfc/Notepad/src/Notepad.java`を参照してください。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTR15q_ELI/AAAAAAAAAh0/2H6dW1g0eiY/s800/ResourceMenuBar.png)

### サンプルコード
<pre class="prettyprint"><code>public JMenuBar createMenubar() {
  JMenuBar mb = new JMenuBar();
  String[] menuKeys = tokenize(getResourceString("menubar"));
  for(int i=0;i&lt;menuKeys.length;i++) {
    JMenu m = createMenu(menuKeys[i]);
    if(m != null) {
      mb.add(m);
    }
  }
  return mb;
}

private JMenu createMenu(String key) {
  String[] itemKeys = tokenize(getResourceString(key));
  String mitext = getResourceString(key + labelSuffix);
  JMenu menu = new JMenu(mitext);
  String mn = getResourceString(key + mneSuffix);
  if(mn!=null) {
    String tmp = mn.toUpperCase().trim();
    if(tmp.length()==1) {
      if(mitext.indexOf(tmp)&lt;0) {
       menu.setText(mitext+" ("+tmp+")");
      }
      byte[] bt = tmp.getBytes();
      menu.setMnemonic((int) bt[0]);
    }
  }
  for(int i=0;i&lt;itemKeys.length;i++) {
    if(itemKeys[i].equals("-")) {
      menu.addSeparator();
    }else{
      JMenuItem mi = createMenuItem(itemKeys[i]);
      menu.add(mi);
    }
  }
  menus.put(key, menu);
  return menu;
}

private JMenuItem createMenuItem(String cmd) {
  String mitext = getResourceString(cmd + labelSuffix);
  JMenuItem mi = new JMenuItem(mitext);
  URL url = getResource(cmd+imageSuffix);
  if(url!=null) {
    mi.setHorizontalTextPosition(JButton.RIGHT);
    mi.setIcon(new ImageIcon(url));
  }
  String astr = getResourceString(cmd + actionSuffix);
  if(astr == null) {
    astr = cmd;
  }
  String mn = getResourceString(cmd + mneSuffix);
  if(mn!=null) {
    String tmp = mn.toUpperCase().trim();
    if(tmp.length()==1) {
      if(mitext.indexOf(tmp)&lt;0) {
        mi.setText(mitext+" ("+tmp+")");
      }
      byte[] bt = tmp.getBytes();
      mi.setMnemonic((int) bt[0]);
    }
  }
  mi.setActionCommand(astr);
  Action a = getAction(astr);
  if(a!=null) {
    mi.addActionListener(a);
    //a.addPropertyChangeListener(createActionChangeListener(mi));
    mi.setEnabled(a.isEnabled());
  }else{
    mi.setEnabled(false);
  }
  menuItems.put(cmd, mi);
  return mi;
}

public JMenuItem getMenuItem(String cmd) {
  return (JMenuItem) menuItems.get(cmd);
}

public JMenu getMenu(String cmd) {
  return (JMenu) menus.get(cmd);
}

public Action getAction(String cmd) {
  return (Action) commands.get(cmd);
}

public Action[] getActions() {
  return actions;
}
</code></pre>

### 解説
アプリケーションの起動時に、リソースファイルからメニューのテキストの生成、アイコン、ショートカットなどの指定を行います。

上記のサンプルでは、バージョンと終了しか機能しないので、このページにある`src.zip`の`Main.properties.utf8`、`Main_ja_JP.properties.utf8`(日本語用)といったリソースファイルを編集したり、新しいリソースファイルを作成してみてください。

ソースコードの方では以下のように`defaultActions`に、上記の`properties`ファイルに書いた`Action`を追加します。

<pre class="prettyprint"><code>public Action[] defaultActions={
  new NewAction(),
  //new OpenAction(),
  new ExitAction(),
  new HelpAction(),
  new VersionAction(),
};
</code></pre>

リソースファイルで日本語などをそのまま使用することは出来ないので、以下のように`ant`から`native2ascii`でユニコードエスケープしています。

<pre class="prettyprint"><code>&lt;condition property="have.resources"&gt;
 &lt;available file="${res.dir}" /&gt;
&lt;/condition&gt;
&lt;target name="prepare-resource" depends="prepare" if="have.resources"&gt;
 &lt;mkdir dir="${build.res}" /&gt;
 &lt;native2ascii encoding="UTF-8" src="${res.dir}" dest="${build.res}"
               includes="**/*.properties.utf8" ext="" /&gt;
 &lt;copy todir="${build.res}"&gt;
  &lt;fileset dir="${res.dir}" excludes="**/*.properties.*, **/*.bak" /&gt;
 &lt;/copy&gt;
&lt;/target&gt;
</code></pre>

面倒な場合は、`JDK 1.5`での、`XML`に対応した`Properties`を使用するようにしてみてください。

- 参考: [J2SE 5.0 Tiger 虎の穴 Properties](http://www.javainthebox.net/laboratory/J2SE1.5/TinyTips/Properties/Properties.html)

<!-- dummy comment line for breaking list -->

- - - -
`JDK 1.6`なら、`native2ascii`で変換しなくても、リソースファイルのエンコードを指定して読み込むことが出来ます。

- 参考
    - [Java 小ネタ千夜一夜 第13夜 Java SE 6はnative2ascii使わなくていいのはみんな知っていると思うが](http://d.hatena.ne.jp/shin/20090707/p4)
    - [ResourceBundle.Control (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/util/ResourceBundle.Control.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>ResourceBundle res = ResourceBundle.getBundle(baseName, new ResourceBundle.Control() {
  public java.util.List&lt;String&gt; getFormats(String baseName) {
    if (baseName == null) throw new NullPointerException();
    return Arrays.asList("properties");
  }
  public ResourceBundle newBundle(
      String baseName, Locale locale, String format, ClassLoader loader, boolean reload)
        throws IllegalAccessException, InstantiationException, IOException {
    if (baseName == null || locale == null || format == null || loader == null)
        throw new NullPointerException();
    ResourceBundle bundle = null;
    if (format.equals("properties")) {
      String bundleName = toBundleName(baseName, locale);
      String resourceName = toResourceName(bundleName, format);
      InputStream stream = null;
      if (reload) {
        URL url = loader.getResource(resourceName);
        if (url != null) {
          URLConnection connection = url.openConnection();
          if (connection != null) {
            connection.setUseCaches(false);
            stream = connection.getInputStream();
          }
        }
      } else {
        stream = loader.getResourceAsStream(resourceName);
      }
      if (stream != null) {
        //BufferedInputStream bis = new BufferedInputStream(stream);
        Reader r = new BufferedReader(new InputStreamReader(stream, "UTF-8"));
        bundle = new PropertyResourceBundle(r);
        r.close();
      }
    }
    return bundle;
  }
});
</code></pre>

### コメント
